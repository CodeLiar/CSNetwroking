//
//  TestAPIManager.m
//  CSNetworking
//
//  Created by Geass on 9/27/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import "TestAPIManager.h"

@implementation TestAPIManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}

#pragma mark - CSAPIManager

- (NSString *)pathName
{
    return @"/v3/geocode/regeo";
}

- (NSString *)hostName
{
    return @"restapi.amap.com";
}

- (NSString *)schemeName
{
    return @"http";
}

- (BOOL)shouldCache
{
    return YES;
}

- (NSTimeInterval)cacheOutdateTimeSeconds
{
    return 10;
}

- (CSAPIManagerRequestType)requestType
{
    return CSAPIManagerRequestTypeGet;
}

#pragma mark - loadStubData

- (void)loadStubData
{
    [super loadStubData];
//    NSDictionary *dic = @{@"key": @"value"};
    __weak typeof(self) weakSelf = self;
    
    NSError *error = [NSError errorWithDomain:NSURLErrorFailingURLErrorKey code:-100000 userInfo:nil];
    [self addAPIStubWithTag:@"demo" responseData:@"success" statusCode:200 requestTime:3 responseTime:3 condition:^BOOL(NSURLRequest * _Nonnull request) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        return [request.URL.path isEqualToString:strongSelf.pathName];
    }];
}


#pragma mark - CTAPIManagerValidator

- (BOOL)manager:(__kindof CSAPIBaseManager *)manager isCorrectWithParamsData:(id)data
{
    return YES;
}

- (BOOL)manager:(__kindof CSAPIBaseManager *)manager isCorrectWithCallBackData:(id)data
{
    if (![data isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    
    return YES;
}

@end
