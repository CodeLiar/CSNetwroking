//
//  CSAPIProxy.h
//  CSNetworking
//
//  Created by Geass on 9/26/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSURLResponse.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^CSCallback)(CSURLResponse *response);

@interface CSAPIProxy : NSObject

+ (instancetype)sharedInstance;

- (NSInteger)callGETWithParams:(NSDictionary *)params domainName:(NSString *)domainName methodName:(NSString *)methodName success:(nullable CSCallback)success fail:(nullable CSCallback)fail;
- (NSInteger)callPOSTWithParams:(NSDictionary *)params domainName:(NSString *)domainName methodName:(NSString *)methodName success:(nullable CSCallback)success fail:(nullable CSCallback)fail;
- (NSInteger)callPUTWithParams:(NSDictionary *)params domainName:(NSString *)domainName methodName:(NSString *)methodName success:(nullable CSCallback)success fail:(nullable CSCallback)fail;
- (NSInteger)callDELETEWithParams:(NSDictionary *)params domainName:(NSString *)domainName methodName:(NSString *)methodName success:(nullable CSCallback)success fail:(nullable CSCallback)fail;


- (NSNumber *)callAPIWithRequest:(NSURLRequest *)request success:(nullable CSCallback)success fail:(nullable CSCallback)fail;
- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;

@end
NS_ASSUME_NONNULL_END
