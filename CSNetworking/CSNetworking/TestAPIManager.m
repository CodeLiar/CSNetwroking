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

- (NSString *)methodName
{
    return @"geocode/regeo";
}

- (NSString *)serviceType
{
    return kCSServiceGDMapV3;
}

- (BOOL)shouldCache
{
    return NO;
}

- (CSAPIManagerRequestType)requestType
{
    return CSAPIManagerRequestTypeGet;
}

- (NSDictionary *)reformParams:(NSDictionary *)params
{
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    resultParams[@"key"] = [[CSServiceFactory sharedInstance] serviceWithIdentifier:kCSServiceGDMapV3].publicKey;
    resultParams[@"location"] = [NSString stringWithFormat:@"%@,%@", params[@"kTestAPIManagerParamsKeyLongitude"], params[@"kTestAPIManagerParamsKeyLatitude"]];
    resultParams[@"output"] = @"json";
    return resultParams;
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
