//
//  LDService.m
//  CSNetworking
//
//  Created by Geass on 9/26/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import "LDService.h"
#import "CSAppContext.h"

@implementation LDService

- (BOOL)isOnline
{
    return [CSAppContext sharedInstance].isOnline;
}

- (NSString *)offlineAPIBaseUrl
{
    return @"http://restapi.amap.com";
}

- (NSString *)onlineAPIBaseUrl
{
    return @"http://restapi.amap.com";
}

- (NSString *)offlineAPIVersion
{
    return @"v3";
}

- (NSString *)onlineAPIVersion
{
    return @"v3";
}

- (NSString *)onlinePublicKey
{
    return @"384ecc4559ffc3b9ed1f81076c5f8424";
}

- (NSString *)offlinePublicKey
{
    return @"384ecc4559ffc3b9ed1f81076c5f8424";
}

- (NSString *)onlinePrivateKey
{
    return @"";
}

- (NSString *)offlinePrivateKey
{
    return @"";
}

@end
