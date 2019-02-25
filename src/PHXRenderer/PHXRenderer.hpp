//
//  Renderer.h
//  phoenix-apple-components
//
//  Created by Bodie Solomon on 2/7/19.
//

#ifndef PHX_PHXRenderer_hpp
#define PHX_PHXRenderer_hpp

@import MetalKit;

#include "PHXResourceManager.hpp"

@protocol PHXRenderer<MTKViewDelegate>

+ (nullable instancetype)makeWithView:(nonnull MTKView *)view
                       withFullscreen:(BOOL)fullscreen;

- (void) update;
- (void) clear;
- (void) draw;
- (void) drawPointAt:(simd_int2)point withColor:(MTLClearColor)color;

@end

/// PHXRenderer is the core implementation of the Renderer class for Phoenix
/// using Apple's Metal APIs.  It also serves as a MTKViewDelegate which may be
/// proxied into by the Phoenix wrapper for the Apple stack.  It should not
/// respond directly to events, but instead be used by an intermediate layer,
/// where additional behavior may be added via subclassing.
///
/// Note that it conforms to the MTKViewDelegate protocol directly, so it may be
/// used directly in UI tests, or subclassed, etc.
@interface PHXMetalRenderer : NSObject<PHXRenderer>

@end

#endif /* PHX_PHXRenderer_hpp */
