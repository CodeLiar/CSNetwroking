//
//  CSRequestGenerator.h
//  CSNetworking
//
//  Created by Geass on 9/26/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface CSRequestGenerator : NSObject

+ (instancetype)sharedInstance;

- (NSURLRequest *)generateGETRequestWithDomainName:(NSString *)domainName requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;
- (NSURLRequest *)generatePOSTRequestWithDomainName:(NSString *)domainName requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;
- (NSURLRequest *)generatePutRequestWithDomainName:(NSString *)domainName requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;
- (NSURLRequest *)generateDeleteRequestWithDomainName:(NSString *)domainName requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;

@end
NS_ASSUME_NONNULL_END
