//
//  Drawer.h
//  phoenix-apple-components
//
//  Created by Bodie Solomon on 2/12/19.
//

#ifndef PHX_Drawer_h
#define PHX_Drawer_h

@import MetalKit;

@interface PHXDrawer : NSObject

@property MTLSize viewportSize;

+ (void) drawInView:(nonnull MTKView *)view
           withSize:(MTLSize)size
      usingPipeline:(nonnull id<MTLRenderPipelineState>) pipeline
   withCommandQueue:(nonnull id<MTLCommandQueue>) cmdQueue
   withInputTexture:(nonnull id<MTLTexture>)texture;
// TODO:          andCommit:(BOOL)commit;

@end

#endif /* PHX_Drawer_h */
