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

@class CSAPIBaseManager;
@interface CSAPIProxy : NSObject

+ (instancetype)sharedInstance;

- (NSInteger)callAPIWithManager:(CSAPIBaseManager *)manager params:(NSDictionary *)params success:(nullable CSCallback)success fail:(nullable CSCallback)fail;
- (NSNumber *)callAPIWithRequest:(NSURLRequest *)request success:(nullable CSCallback)success fail:(nullable CSCallback)fail;
- (NSURLRequest *)generateRequestWithAPIManager:(CSAPIBaseManager *)manager params:(NSDictionary *)params;

- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;

@end
NS_ASSUME_NONNULL_END
