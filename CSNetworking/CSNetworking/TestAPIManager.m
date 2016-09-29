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


#pragma mark - CTAPIManagerValidator
- (BOOL)manager:(__kindof CSAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return YES;
}

- (BOOL)manager:(__kindof CSAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{
    if ([data[@"status"] isEqualToString:@"0"]) {
        return NO;
    }
    
    return YES;
}

@end
