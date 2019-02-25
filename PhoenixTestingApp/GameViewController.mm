//
//  GameViewController.m
//  PhoenixTestingApp
//
//  Created by Bodie Solomon on 2/14/19.
//

#import "GameViewController.h"

#import "Renderer.hpp"

@implementation GameViewController {
    MTKView *_view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.identifier = @"View controller";

    _view = (MTKView *)self.view;

    _view.device = MTLCreateSystemDefaultDevice();

    if(!_view.device)
    {
        NSLog(@"Metal is not supported on this device");
        self.view = [[NSView alloc] initWithFrame:self.view.frame];
        return;
    }

    _renderer = [PHXRenderer makeWithView:_view withFullscreen:NO];

    [_renderer mtkView:_view drawableSizeWillChange:_view.bounds.size];

    _view.delegate = _renderer;
}

@end
