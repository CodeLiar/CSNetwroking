//
//  CSNetworkingTests.m
//  CSNetworkingTests
//
//  Created by Geass on 9/23/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestAPIManager.h"

@interface CSNetworkingTests : XCTestCase <CSAPIManagerParamSource, CSAPIManagerCallBackDelegate>

@end

@implementation CSNetworkingTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    TestAPIManager *manager = [[TestAPIManager alloc] init];
    manager.delegate = self;
    manager.paramSource = self;
    [manager loadStubData];
    [manager loadData];
    CFRunLoopRun();
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

#pragma mark - CSAPIManagerParamSource

- (NSDictionary *)paramsForAPI:(__kindof CSAPIBaseManager *)manager
{
    return @{
             @"location": [NSString stringWithFormat:@"%@,%@", @(121.454290), @(31.228000)],
             @"output": @"json",
             @"key": @"384ecc4559ffc3b9ed1f81076c5f8424"
             };
}

#pragma mark - CSAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(__kindof CSAPIBaseManager *)manager
{
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    CFRunLoopStop(runloop);
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", [manager fetchDataWithReformer:nil]);
    XCTAssertTrue(NO, "request assert");
}


- (void)managerCallAPIDidFailed:(__kindof CSAPIBaseManager *)manager
{
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    CFRunLoopStop(runloop);
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%ld", (long)manager.errorType);
}

@end
