//
//  Renderer.h
//  phoenix-apple-components
//
//  Created by Bodie Solomon on 2/7/19.
//

#ifndef Renderer_h
#define Renderer_h

@import MetalKit;

#include "ResourceManager.hpp"

/// PHXRenderer is the core implementation of the Renderer class for Phoenix
/// using Apple's Metal APIs.  It also serves as a MTKViewDelegate which may be
/// proxied into by the Phoenix wrapper for the Apple stack.  It should not
/// respond directly to events, but instead be used by an intermediate layer,
/// where additional behavior may be added via subclassing.
@interface PHXRenderer : NSObject<MTKViewDelegate>

+ (nullable instancetype)makeWithView:(nonnull MTKView *)view;

@end

#endif /* Renderer_h */
