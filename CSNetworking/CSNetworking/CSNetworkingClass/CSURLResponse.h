//
//  CSURLResponse.h
//  CSNetworking
//
//  Created by Geass on 9/26/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSNetworkingConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CSURLResponseStatus)
{
    CSURLResponseStatusSuccess, //作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的CSAPIBaseManager来决定。
    CSURLResponseStatusErrorTimeout,
    CSURLResponseStatusErrorNoNetwork // 默认除了超时以外的错误都是无网络错误。
};

@interface CSURLResponse : NSObject

@property (nonatomic, assign, readonly) CSURLResponseStatus status;
@property (nonatomic, copy, readonly) NSString *contentString;
@property (nonatomic, copy, readonly, nullable) id content;
@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonatomic, copy, readonly, nullable) NSURLRequest *request;
@property (nonatomic, copy, readonly) NSData *responseData;
@property (nonatomic, copy, nullable) NSDictionary *requestParams;

@property (nonatomic, assign, readonly) BOOL isCache;

- (instancetype)initWithResponseString:(NSString *)responseString
                             requestId:(NSNumber *)requestId
                               request:(NSURLRequest *)request
                          responseData:(NSData *)responseData
                                status:(CSURLResponseStatus)status;

- (instancetype)initWithResponseString:(NSString *)responseString
                             requestId:(NSNumber *)requestId
                               request:(NSURLRequest *)request
                          responseData:(NSData *)responseData
                                 error:(NSError *)error;

// 使用initWithData的response，它的isCache是YES，上面两个函数生成的response的isCache是NO
- (instancetype)initWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
