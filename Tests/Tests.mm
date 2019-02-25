//
//  Tests.m
//  Tests
//
//  Created by Bodie Solomon on 2/7/19.
//

#import <XCTest/XCTest.h>

#import "PHXRenderer.hpp"
#import "Renderer.hpp"

@interface FooRenderer : NSObject<PHXRenderer>
@end

@implementation FooRenderer

+ (nullable instancetype)makeWithView:(nonnull MTKView *)view
                       withFullscreen:(BOOL)fullscreen {
    FooRenderer* tmp = [[super alloc] init];
    return tmp;
}

- (void)update {}
- (void)clear {}
- (void)draw {}
- (void)drawPointAt:(simd_int2)point withColor:(MTLClearColor)color {}

- (void)drawInMTKView:(nonnull MTKView *)view {}
- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {}

@end

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    MTKView* v = nil;
    auto pr = [PHXMetalRenderer makeWithView:v withFullscreen:NO];
    auto r = mtlp::Renderer<PHXMetalRenderer>(pr);
    
    // Make sure these methods exist; no real "test" yet.
    r.update();
    r.clear();
    r.draw();
    r.drawPoint(0, 0, 0xFFFFFFFF);
    
    // MetalRenderer is an alias for mtlp::Renderer<PHXRenderer>.
    r = mtlp::MetalRenderer(pr);
    r.update();
    r.clear();
    r.draw();
    r.drawPoint(0, 0, 0xFFFFFFFF);
    
    auto fr = [FooRenderer makeWithView:v withFullscreen:NO];
    auto rr = mtlp::Renderer<FooRenderer>(fr);
    rr.update();
    rr.clear();
    rr.draw();
    rr.drawPoint(0, 0, 0xFFFFFFFF);
}

- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
}

@end
