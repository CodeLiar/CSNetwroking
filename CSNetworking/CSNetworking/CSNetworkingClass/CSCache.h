//
//  CSCache.h
//  CSNetworking
//
//  Created by Geass on 9/26/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CSAPIBaseManager;
@interface CSCache : NSObject


+ (instancetype)sharedInstance;

- (NSString *)keyWithAPIManager:(CSAPIBaseManager *)manager
                  requestParams:(NSDictionary *)requestParams;

- (nullable NSData *)fetchCachedDataWithAPIManager:(CSAPIBaseManager *)manager
                                     requestParams:(NSDictionary *)requestParams;

- (void)saveCacheWithData:(NSData *)cachedData
               APIManager:(CSAPIBaseManager *)manager
            requestParams:(NSDictionary *)requestParams;

- (void)deleteCacheWithAPIManager:(CSAPIBaseManager *)manager
                    requestParams:(NSDictionary *)requestParams;

- (nullable NSData *)fetchCachedDataWithKey:(NSString *)key;
- (void)saveCacheWithData:(NSData *)cachedData key:(NSString *)key cacheOutdateTimeSeconds:(NSTimeInterval)cacheOutdateTimeSeconds;
- (void)deleteCacheWithKey:(NSString *)key;
- (void)clean;

- (void)setCacheLimitCount:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
