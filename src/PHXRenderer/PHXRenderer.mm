//
//  Renderer.m
//  Renderer
//
//  Created by Bodie Solomon on 2/7/19.
//

@import MetalKit;

#include "PHXRenderer.hpp"
#include "PHXResourceManager.hpp"

@implementation PHXMetalRenderer {
    PHXResourceManager* _manager;
}

+ (nullable instancetype)makeWithView:(nonnull MTKView *)view
                       withFullscreen:(BOOL)fullscreen {

    PHXMetalRenderer* tmp = [[super alloc] init];

    if (!tmp) {
        NSLog(@"Failed to allocate PHXRenderer");
        return nil;
    }

    auto manager = [PHXResourceManager makeWithDevice:view.device
                                             withView:view
                                       withFullscreen:fullscreen];
    if (!manager) {
        NSLog(@"Failed to create resource manager for PHXRenderer");
        return nil;
    }

    tmp->_manager = manager;

    NSError *err = NULL;
    [manager loadShadersWithFormat:MTLPixelFormatRGBA8Unorm withError:err];
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

- (void) update {

}

- (void) clear {

}

- (void) draw {

}

- (void) drawPointAt:(simd_int2)point withColor:(MTLClearColor)color {

}

@end
