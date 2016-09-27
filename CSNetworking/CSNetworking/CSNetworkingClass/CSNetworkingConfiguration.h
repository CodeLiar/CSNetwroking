//
//  CSNetworkingConfiguration.h
//  CSNetworking
//
//  Created by Geass on 9/26/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#ifndef CSNetworkingConfiguration_h
#define CSNetworkingConfiguration_h


typedef NS_ENUM(NSInteger, CSAppType) {
    CSAppTypexxx
};

typedef NS_ENUM(NSUInteger, CSURLResponseStatus)
{
    CSURLResponseStatusSuccess, //作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的CSAPIBaseManager来决定。
    CSURLResponseStatusErrorTimeout,
    CSURLResponseStatusErrorNoNetwork // 默认除了超时以外的错误都是无网络错误。
};

static NSString *CSKeychainServiceName = @"xxxxx";
static NSString *CSUDIDName = @"xxxx";
static NSString *CSPasteboardType = @"xxxx";

static BOOL kCSShouldCache = YES;
static BOOL kCSServiceIsOnline = NO;
static NSTimeInterval kCSNetworkingTimeoutSeconds = 20.0f;
static NSTimeInterval kCSCacheOutdateTimeSeconds = 300; // 5分钟的cache过期时间
static NSUInteger kCSCacheCountLimit = 1000; // 最多1000条cache

#endif /* CSNetworkingConfiguration_h */
