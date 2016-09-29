//
//  CSLogger.h
//  CSNetworking
//
//  Created by Geass on 9/26/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSService, CSURLResponse;
@interface CSLogger : NSObject


+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response responseString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error;
+ (void)logDebugInfoWithCachedResponse:(CSURLResponse *)response pathName:(NSString *)pathName hostName:(NSString *)hostName schemeName:(NSString *)schemeName;

+ (instancetype)sharedInstance;

@end
