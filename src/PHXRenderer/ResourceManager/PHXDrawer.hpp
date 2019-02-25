//
//  Drawer.h
//  phoenix-apple-components
//
//  Created by Bodie Solomon on 2/12/19.
//

#ifndef PHX_RM_Drawer_hpp
#define PHX_RM_Drawer_hpp

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

#endif /* PHX_RM_Drawer_hpp */
