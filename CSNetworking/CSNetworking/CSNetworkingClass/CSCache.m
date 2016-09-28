//
//  CSCache.m
//  CSNetworking
//
//  Created by Geass on 9/26/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import "CSCache.h"
#import "NSDictionary+CSNetworkingMethods.h"
#import "CSNetworkingConfiguration.h"
#import "CSCachedObject.h"

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

- (NSString *)keyWithDomainName:(NSString *)domainName methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams
{
    return [NSString stringWithFormat:@"%@%@%@", domainName, methodName, [requestParams CS_urlParamsStringSignature:NO]];
}

- (nullable NSData *)fetchCachedDataWithDomainName:(NSString *)domainName methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams
{
    return [self fetchCachedDataWithKey:[self keyWithDomainName:domainName methodName:methodName requestParams:requestParams]];
}

- (void)saveCacheWithData:(NSData *)cachedData domainName:(NSString *)domainName methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams cacheOutdateTimeSeconds:(NSInteger)cacheOutdateTimeSeconds
{
    [self saveCacheWithData:cachedData key:[self keyWithDomainName:domainName methodName:methodName requestParams:requestParams] cacheOutdateTimeSeconds:cacheOutdateTimeSeconds];
}

- (void)deleteCacheWithDomainName:(NSString *)domainName methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams
{
    [self deleteCacheWithKey:[self keyWithDomainName:domainName methodName:methodName requestParams:requestParams]];
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

- (void)saveCacheWithData:(NSData *)cachedData key:(NSString *)key cacheOutdateTimeSeconds:(NSInteger)cacheOutdateTimeSeconds
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
