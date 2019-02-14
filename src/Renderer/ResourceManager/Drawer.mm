//
//  ResourceManagerDraw.m
//  Renderer
//
//  Created by Bodie Solomon on 2/12/19.
//

#import "Drawer.hpp"

#import "Shaders.h"

@implementation PHXDrawer

+ (void) drawInView:(nonnull MTKView *)view
           withSize:(MTLSize)size
      usingPipeline:(nonnull id<MTLRenderPipelineState>)pipeline
   withCommandQueue:(nonnull id<MTLCommandQueue>)cmdQueue
   withInputTexture:(nonnull id<MTLTexture>)texture {

    auto w = static_cast<double>(size.width),
        h = static_cast<double>(size.height);
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
    auto buf = [cmdQueue commandBuffer];
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

    [encoder setRenderPipelineState:pipeline];

    // TODO: Automate configuration of shader parameters as shader-bundled traits.
    [encoder setVertexBytes:fsQuad
                     length:sizeof(fsQuad)
                    atIndex:PHXVertexInputIndexVertices];

    [encoder setVertexBytes:&size
                     length:sizeof(size)
                    atIndex:PHXVertexInputIndexViewportSize];

    [encoder setFragmentTexture:texture
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

@end
