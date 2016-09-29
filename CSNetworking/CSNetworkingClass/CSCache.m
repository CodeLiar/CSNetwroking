//
//  CSCache.m
//  CSNetworking
//
//  Created by Geass on 9/26/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import "CSCache.h"
#import "NSDictionary+CSNetworkingMethods.h"
#import "CSCachedObject.h"
#import "CSAPIBaseManager.h"

@interface CSCache ()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation CSCache

#pragma mark - getters and setters

- (NSCache *)cache
{
    if (_cache == nil) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = 1000;
    }
    return _cache;
}

#pragma mark - life cycle

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static CSCache *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CSCache alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public method

- (NSString *)keyWithAPIManager:(CSAPIBaseManager *)manager requestParams:(NSDictionary *)requestParams
{
    return [NSString stringWithFormat:@"%@://%@%@%@", manager.schemeName, manager.hostName, manager.pathName, [requestParams CS_urlParamsStringSignature:NO]];
}

- (NSData *)fetchCachedDataWithAPIManager:(CSAPIBaseManager *)manager requestParams:(NSDictionary *)requestParams
{
    return [self fetchCachedDataWithKey:[self keyWithAPIManager:manager requestParams:requestParams]];
}

- (void)saveCacheWithData:(NSData *)cachedData APIManager:(CSAPIBaseManager *)manager requestParams:(NSDictionary *)requestParams
{
    [self saveCacheWithData:cachedData key:[self keyWithAPIManager:manager requestParams:requestParams] cacheOutdateTimeSeconds:manager.cacheOutdateTimeSeconds];
}

- (void)deleteCacheWithAPIManager:(CSAPIBaseManager *)manager requestParams:(NSDictionary *)requestParams
{
    [self deleteCacheWithKey:[self keyWithAPIManager:manager requestParams:requestParams]];
}

- (nullable NSData *)fetchCachedDataWithKey:(NSString *)key
{
    CSCachedObject *cachedObject = [self.cache objectForKey:key];
    if (cachedObject.isOutdataed || cachedObject.isEmpty) {
        return nil;
    } else {
        return cachedObject.content;
    }
}

- (void)saveCacheWithData:(NSData *)cachedData key:(NSString *)key cacheOutdateTimeSeconds:(NSTimeInterval)cacheOutdateTimeSeconds
{
    CSCachedObject *cachedObject = [self.cache objectForKey:key];
    if (cachedObject == nil) {
        cachedObject = [[CSCachedObject alloc] initWithContent:cachedData cacheOutdateTimeSeconds:cacheOutdateTimeSeconds];
    }
    [cachedObject updateContent:cachedData cacheOutdateTimeSeconds:cacheOutdateTimeSeconds];
    [self.cache setObject:cachedObject forKey:key];
}

- (void)deleteCacheWithKey:(NSString *)key
{
    [self.cache removeObjectForKey:key];
}

- (void)clean
{
    [self.cache removeAllObjects];
}

- (void)setCacheLimitCount:(NSInteger)count
{
    self.cache.countLimit = count;
}

@end
