//
//  Renderer.m
//  Renderer
//
//  Created by Bodie Solomon on 2/7/19.
//

@import MetalKit;

#include "ResourceManager.hpp"
#include "Renderer.hpp"

@implementation PHXRenderer {
    PHXResourceManager* _manager;
}

+ (nullable instancetype)makeWithView:(nonnull MTKView *)view {
    
    PHXRenderer* tmp = [[super alloc] init];
    
    if (!tmp) {
        NSLog(@"Failed to allocate PHXRenderer");
        return nil;
    }
    
    auto manager = [PHXResourceManager makeWithDevice:view.device
                                             withView:view
                                       withFullscreen:YES];
    
    if (!manager) {
        NSLog(@"Failed to create resource manager for PHXRenderer");
        return nil;
    }
    
    tmp->_manager = manager;
    
    auto fmt = MTLPixelFormatRGBA8Unorm;
    NSError *err = NULL;
    
    [manager loadShadersWithFormat:fmt withError:err];
    if (err) {
        NSLog(@"Failed to load shaders: %@", err);
        return nil;
    }
    
    [manager prepareTexturesWithCGSize:view.drawableSize];
    
    [manager createCommandQueue];
    
    return tmp;
}

- (void)drawInMTKView:(nonnull MTKView *)view { 
    [_manager drawInView:view];
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    [_manager updateToCGSize:size];
}

@end
