//
//  GameViewController.h
//  PhoenixTestingApp
//
//  Created by Bodie Solomon on 2/14/19.
//

#import <Cocoa/Cocoa.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

#import "Renderer.hpp"

// Our macOS view controller.
@interface GameViewController : NSViewController

@property PHXRenderer* renderer;

@end
