//
//  ResourceManager.cpp
//  Renderer
//
//  Created by Bodie Solomon on 2/8/19.
//

#include "ResourceManager.hpp"
#include "Shaders.h"

@implementation PHXResourceManager {
    // Note that the view and device are owned by the creator of this resource,
    // so it doesn't need to manage their lifetimes.
    __weak id<MTLDevice> _device;
    __weak MTKView* _view;
    
    // Texture-related handles and parameters.
    MTLPixelFormat _format;
    id<MTLTexture> _texture;

    MTLSize _viewportSize;
    
    id<MTLCommandQueue> _cmdQueue;
    id<MTLRenderPipelineState> _pipeline;
}

+ (nullable instancetype) makeWithDevice:(id<MTLDevice>) device
                                withView:(nonnull MTKView *)view
                          withFullscreen:(BOOL)fs {
                                    
    PHXResourceManager* tmp = [[super alloc] init];
    if (!tmp) {
        return tmp;
    }
    
    tmp->_device = device;
    tmp->_view = view;

    if (fs) {
      [tmp->_view enterFullScreenMode:[NSScreen mainScreen]
                          withOptions:@{NSFullScreenModeAllScreens: @YES}];
    }
                              
    return tmp;
}

- (void) drawInView:(nonnull MTKView *)view {
    auto w = static_cast<double>(_viewportSize.width),
        h = static_cast<double>(_viewportSize.height);
    auto fw = float(w),
        fh = float(h);
    
    const PHXVertex fsQuad[] = {
        { {  fw, -fh }, { 1.f, 0.f } },
        { { -fw, -fh }, { 0.f, 0.f } },
        { { -fw,  fh }, { 0.f, 1.f } },
        
        { {  fw, -fh }, { 1.f, 0.f } },
        { { -fw,  fh }, { 0.f, 1.f } },
        { {  fw,  fh }, { 1.f, 1.f } },
    };
    
    // Create a new command buffer for each render pass to the current drawable
    auto buf = [_cmdQueue commandBuffer];
    buf.label = @"Draw command buffer";

    // Obtain a renderPassDescriptor generated from the view's drawable textures.
    auto descriptor = view.currentRenderPassDescriptor;

    if(descriptor == nil) {
        NSLog(@"Unable to get render pass descriptor!");
        [buf commit];
        return;
    }

    // Create a render command encoder so we can render into something
    auto encoder = [buf renderCommandEncoderWithDescriptor:descriptor];
    encoder.label = @"Render command encoder";
    
    // Set the region of the drawable to which we'll draw (the whole thing.)
    [encoder setViewport:(MTLViewport){
        0.0, 0.0,
        w, h,
        -1.0, 1.0,
     }];
    
    [encoder setRenderPipelineState:_pipeline];
    
    // TODO: Automate configuration of shader parameters as shader-bundled traits.
    [encoder setVertexBytes:fsQuad
                     length:sizeof(fsQuad)
                    atIndex:PHXVertexInputIndexVertices];
    
    [encoder setVertexBytes:&_viewportSize
                     length:sizeof(_viewportSize)
                    atIndex:PHXVertexInputIndexViewportSize];
    
    [encoder setFragmentTexture:_texture
                        atIndex:PHXTextureIndexOutput];
    
    // Draw the vertices of our triangles
    [encoder drawPrimitives:MTLPrimitiveTypeTriangle
                vertexStart:0
                vertexCount:6];
    
    [encoder endEncoding];
    
    // Schedule a present once the framebuffer is complete using the current drawable
    [buf presentDrawable:view.currentDrawable];

    // Finalize rendering here & push the command buffer to the GPU
    [buf commit];
}

- (void) loadShadersWithFormat:(MTLPixelFormat)fmt
                     withError:(NSError*)err {
                         
    _format = fmt;
    
    // Set the view's color format to the target.
    _view.colorPixelFormat = fmt;
    
    // Load all known Metal shaders for the device.
    auto defaultLibrary = [_device newDefaultLibrary];
    
    auto vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader"];
    auto fragmentFunction = [defaultLibrary newFunctionWithName:@"fragmentShader"];
    
    // Set up a Metal pipeline descriptor.
    auto pipelineDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    pipelineDescriptor.label = @"Default rendering pipeline";
    pipelineDescriptor.vertexFunction = vertexFunction;
    pipelineDescriptor.fragmentFunction = fragmentFunction;
    pipelineDescriptor.colorAttachments[0].pixelFormat = fmt;
    
    _pipeline = [_device newRenderPipelineStateWithDescriptor:pipelineDescriptor
                                                        error:&err];
}

- (void) prepareTexturesWithCGSize:(CGSize)size {
    auto uw = static_cast<unsigned long>(size.width),
        uh = static_cast<unsigned long>(size.width);
    
    [self prepareTexturesWithSize:MTLSizeMake(uw, uh, 1)];
}

- (void) prepareTexturesWithSize:(MTLSize)size {
    auto descriptor = [[MTLTextureDescriptor alloc] init];

    // Indicate we're creating a 2D texture.
    descriptor.textureType = MTLTextureType2D;
    
    _viewportSize = size;

    // Indicate that each pixel has a Red, Blue, Green, and Alpha channel, each
    // in an 8 bit unnormalized value (0 maps 0.0 while 255 maps to 1.0).
    descriptor.pixelFormat = _format;
    descriptor.width = size.width;
    descriptor.height = size.height;
    descriptor.depth = size.depth;
    descriptor.usage = MTLTextureUsageShaderWrite | MTLTextureUsageShaderRead;

    _texture = [_device newTextureWithDescriptor:descriptor];
}

- (void) resizeAndCopyTextureToSize:(MTLSize) size {
    auto descriptor = [[MTLTextureDescriptor alloc] init];
    
    descriptor.textureType = MTLTextureType2D;
    
    descriptor.pixelFormat = _format;
    descriptor.width = size.width;
    descriptor.height = size.height;
    descriptor.usage = MTLTextureUsageShaderWrite | MTLTextureUsageShaderRead;
    
    auto tmp = [_device newTextureWithDescriptor:descriptor];
    
    auto buf = [_cmdQueue commandBufferWithUnretainedReferences];
    buf.label = @"Blit to new size";
    
    // Create and encode the texture blit command.
    auto blit = [buf blitCommandEncoder];
    [blit copyFromTexture:_texture
              sourceSlice:0 sourceLevel:0
             sourceOrigin:{0, 0, 0} sourceSize:{_texture.width, _texture.height}
                toTexture:tmp
         destinationSlice:0 destinationLevel:0 destinationOrigin:{0, 0, 0}];
    [blit endEncoding];
    
    // Commit the encoded blit.
    [buf commit];
    
    // Discard the old texture and assign the handle the new one.
    _texture = tmp;
}

- (void) updateToCGSize:(CGSize)size {
    auto uw = static_cast<unsigned long>(size.width),
    uh = static_cast<unsigned long>(size.width);
    
    [self updateToSize:MTLSizeMake(uw, uh, 1)];
}

- (void) updateToSize:(MTLSize)size {
    _viewportSize.width = size.width;
    _viewportSize.height = size.height;
    
    [self resizeAndCopyTextureToSize:size];
}

- (void) createCommandQueue {
    _cmdQueue = [_device newCommandQueue];
}

@end
