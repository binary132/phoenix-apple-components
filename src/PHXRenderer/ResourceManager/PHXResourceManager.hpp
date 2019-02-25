//
//  ResourceManager.hpp
//  Renderer
//
//  Created by Bodie Solomon on 2/8/19.
//

#ifndef PHX_ResourceManager_hpp
#define PHX_ResourceManager_hpp

@import MetalKit;

@interface PHXResourceManager : NSObject

+ (nullable instancetype) makeWithDevice:(id<MTLDevice>)device
                                withView:(nonnull MTKView *)view
                          withFullscreen:(BOOL) fs;

- (void) loadShadersWithFormat:(MTLPixelFormat)fmt
                     withError:(NSError*)err;

- (void) prepareTexturesWithCGSize:(CGSize)size;
- (void) prepareTexturesWithSize:(MTLSize)size;

- (void) createCommandQueue;

- (void) updateToCGSize:(CGSize)size;
- (void) updateToSize:(MTLSize)size;

- (void) drawInView:(nonnull MTKView *)view;

@end

#endif /* PHX_ResourceManager_hpp */
