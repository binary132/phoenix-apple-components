//
//  UITests.m
//  UITests
//
//  Created by Bodie Solomon on 2/7/19.
//

#import <XCTest/XCTest.h>

#import "Renderer.hpp"

@interface UITests : XCTestCase

@end

@implementation UITests

- (void)setUp {
    self.continueAfterFailure = NO;

    // UI tests must launch the application that they test. Doing this in setup
    // will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
}

- (void)tearDown {
}

- (void)testMakeWithView {
    // Use XCTAssert, etc.
//    [PHXRenderer makeWithView: self.view];
}

@end
