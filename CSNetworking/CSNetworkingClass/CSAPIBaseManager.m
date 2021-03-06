//
//  CSAPIBaseManager.m
//  CSNetworking
//
//  Created by Geass on 9/23/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import "CSAPIBaseManager.h"
#import "CSCache.h"
#import "CSAPIProxy.h"
#import "CSLogger.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <OHHTTPStubs/OHHTTPStubs.h>

NSString * const kCSUserTokenInvalidNotification = @"kCSUserTokenInvalidNotification";
NSString * const kCSUserTokenIllegalNotification = @"kCSUserTokenIllegalNotification";

NSString * const kCSUserTokenNotificationUserInfoKeyRequestToContinue = @"kCSUserTokenNotificationUserInfoKeyRequestToContinue";
NSString * const kCSUserTokenNotificationUserInfoKeyManagerToContinue = @"kCSUserTokenNotificationUserInfoKeyManagerToContinue";

NS_ASSUME_NONNULL_BEGIN
@interface CSAPIBaseManager ()

@property (nonatomic, strong, readwrite, nullable) id fetchedRawData;
@property (nonatomic, assign, readwrite) BOOL isLoading;
@property (nonatomic, assign) BOOL isNativeDataEmpty;

@property (nonatomic, copy, readwrite, nullable) NSString *errorMessage;
@property (nonatomic, assign, readwrite) CSAPIManagerErrorType errorType;
@property (nonatomic, strong, nullable) NSMutableArray *requestIdList;
@property (nonatomic, strong) CSCache *cache;

#if DEBUG
@property (nonatomic, strong) NSMutableDictionary *stubsDic;
#endif

@end
NS_ASSUME_NONNULL_END

@implementation CSAPIBaseManager

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegate = nil;
        _validator = nil;
        _paramSource = nil;
        
        _fetchedRawData = nil;
        
        _errorMessage = nil;
        _errorType = CSAPIManagerErrorTypeDefault;
    }
    return self;
}

- (void)dealloc
{
    [self cancelAllRequests];
    self.requestIdList = nil;
    NSLog(@"%s", __FUNCTION__);
#if DEBUG
    if (self.stubsDic.count > 0) {
        [self removeAllAPIStubs];
    }
#endif
}

- (void)loadStubData
{
    [OHHTTPStubs setEnabled:YES];
}

#pragma mark - public method

- (void)cancelAllRequests
{
    [[CSAPIProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID
{
    [self removeRequestIdWithRequestID:requestID];
    [[CSAPIProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

- (id)fetchDataWithReformer:(nullable id<CSAPIManagerDataReformer>)reformer
{
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(manager:reformData:)]) {
        resultData = [reformer manager:self reformData:self.fetchedRawData];
    } else {
        resultData = [self.fetchedRawData mutableCopy];
    }
    return resultData;
}

#pragma mark - HTTPStubs
- (void)addAPIStubWithTag:(NSString *)tag responseData:(id)responseData statusCode:(int)statusCode requestTime:(NSTimeInterval)requestTime responseTime:(NSTimeInterval)responseTime condition:(CSAPIStubsCondition)condition
{
#if DEBUG
    id<OHHTTPStubsDescriptor> testStub = self.stubsDic[tag];
    if (!testStub) {
        testStub = [OHHTTPStubs stubRequestsPassingTest:condition withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
            // Stub txt files with this
            // OHHTTPStubsDownloadSpeedWifi responseTime
            if ([responseData isKindOfClass:[NSError class]]) {
                return [[OHHTTPStubsResponse responseWithError:responseData] requestTime:requestTime responseTime:responseTime];
            }
            else {
                NSData *data = nil;
                if ([responseData isKindOfClass:[NSString class]]) {
                    data = [responseData dataUsingEncoding:NSUTF8StringEncoding];
                } else {
                    data = [NSJSONSerialization dataWithJSONObject:responseData options:0 error:nil];
                }
                return [[OHHTTPStubsResponse responseWithData:data statusCode:statusCode headers:@{@"Content-Type":@"text/plain"}] requestTime:requestTime responseTime:responseTime];
            }
        }];
        testStub.name = tag;
        self.stubsDic[tag] = testStub;
    }
#endif
}

- (void)removeAllAPIStubs
{
#if DEBUG
    for (id<OHHTTPStubsDescriptor> stubs in self.stubsDic.allValues) {
        [OHHTTPStubs removeStub:stubs];
    }
    [self.stubsDic removeAllObjects];
#endif
}

- (void)removeAPIStubWithTag:(NSString *)tag
{
#if DEBUG
    id<OHHTTPStubsDescriptor> stubs = self.stubsDic[tag];
    if (stubs) {
        [OHHTTPStubs removeStub:stubs];
        [self.stubsDic removeObjectForKey:tag];
    }
#endif
}

#pragma mark - private methods
- (void)removeRequestIdWithRequestID:(NSInteger)requestId
{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

- (BOOL)hasCacheWithParams:(NSDictionary *)params
{
    NSData *result = [self.cache fetchCachedDataWithAPIManager:self requestParams:params];
    
    if (result == nil) {
        return NO;
    }
    
//    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
//        __strong typeof (weakSelf) strongSelf = weakSelf;
        CSURLResponse *response = [[CSURLResponse alloc] initWithData:result];
        response.requestParams = params;
        [CSLogger logDebugInfoWithCachedResponse:response pathName:self.pathName hostName:self.hostName schemeName: self.schemeName];
        [self successedOnCallingAPI:response];
    });
    return YES;
}

- (void)loadDataFromNative
{
    NSString *pathName = self.pathName;
    NSDictionary *result = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:pathName];
    
    if (result) {
        self.isNativeDataEmpty = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            CSURLResponse *response = [[CSURLResponse alloc] initWithData:[NSJSONSerialization dataWithJSONObject:result options:0 error:NULL]];
            [self successedOnCallingAPI:response];
        });
    } else {
        self.isNativeDataEmpty = YES;
    }
}

#pragma mark - calling api
- (NSInteger)loadData
{
    [self cancelAllRequests];
    NSDictionary *params = [self.paramSource paramsForAPI:self];
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params
{
    NSInteger requestId = 0;
    NSDictionary *apiParams = [self reformParams:params];
    if ([self shouldCallAPIWithParams:apiParams]) {
        if ([self.validator manager:self isCorrectWithParamsData:apiParams]) {
            
            if ([self shouldLoadFromNative]) {
                [self loadDataFromNative];
            }
            
            // 先检查一下是否有缓存
            if ([self shouldCache] && [self hasCacheWithParams:apiParams]) {
                return 0;
            }
            
            // 实际的网络请求
            if ([self isReachable]) {
                self.isLoading = YES;
                typeof(self) weakSelf = self;
                requestId = [[CSAPIProxy sharedInstance] callAPIWithManager:self params:apiParams success:^(CSURLResponse * _Nonnull response) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;                                        \
                    [strongSelf successedOnCallingAPI:response];
                } fail:^(CSURLResponse * _Nonnull response) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;                                        \
                    [strongSelf failedOnCallingAPI:response withErrorType:CSAPIManagerErrorTypeDefault];
                }];
                [self.requestIdList addObject:@(requestId)];
                NSMutableDictionary *params = [apiParams mutableCopy];
                params[kCSAPIBaseManagerRequestID] = @(requestId);
                [self afterCallingAPIWithParams:params];
                return requestId;
                
            } else {
                [self failedOnCallingAPI:nil withErrorType:CSAPIManagerErrorTypeNoNetWork];
                return requestId;
            }
        } else {
            [self failedOnCallingAPI:nil withErrorType:CSAPIManagerErrorTypeParamsError];
            return requestId;
        }
    }
    return requestId;
}

#pragma mark - api callbacks

- (void)successedOnCallingAPI:(CSURLResponse *)response
{
    self.isLoading = NO;
    self.response = response;
    
    if ([self shouldLoadFromNative]) {
        if (response.isCache == NO) {
            [[NSUserDefaults standardUserDefaults] setObject:response.responseData forKey:[self pathName]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    if (response.content) {
        self.fetchedRawData = [response.content copy];
    } else {
        self.fetchedRawData = [response.responseData copy];
    }
    [self removeRequestIdWithRequestID:response.requestId];
    if ([self.validator manager:self isCorrectWithCallBackData:response.content]) {
        
        if ([self shouldCache] && !response.isCache) {
            [self.cache saveCacheWithData:response.responseData APIManager:self requestParams:response.requestParams];
        }
        
        if ([self beforePerformSuccessWithResponse:response]) {
            if ([self shouldLoadFromNative]) {
                if (response.isCache == YES) {
                    [self.delegate managerCallAPIDidSuccess:self];
                }
                if (self.isNativeDataEmpty) {
                    [self.delegate managerCallAPIDidSuccess:self];
                }
            } else {
                [self.delegate managerCallAPIDidSuccess:self];
            }
        }
        [self afterPerformSuccessWithResponse:response];
    } else {
        [self failedOnCallingAPI:response withErrorType:CSAPIManagerErrorTypeContentError];
    }
}

- (void)failedOnCallingAPI:(CSURLResponse *)response withErrorType:(CSAPIManagerErrorType)errorType
{
    self.isLoading = NO;
    self.response = response;
    self.fetchedRawData = nil;
    self.errorType = errorType;
    [self removeRequestIdWithRequestID:response.requestId];
    if ([self beforePerformFailWithResponse:response]) {
        [self.delegate managerCallAPIDidFailed:self];
    }
    [self afterPerformFailWithResponse:response];
    
//    if ([response.content[@"id"] isEqualToString:@"expired_access_token"]) {
//        // token 失效
//        [[NSNotificationCenter defaultCenter] postNotificationName:kCSUserTokenInvalidNotification
//                                                            object:nil
//                                                          userInfo:@{
//                                                                     kCSUserTokenNotificationUserInfoKeyRequestToContinue:[response.request mutableCopy],
//                                                                     kCSUserTokenNotificationUserInfoKeyManagerToContinue:self
//                                                                     }];
//    } else if ([response.content[@"id"] isEqualToString:@"illegal_access_token"]) {
//        // token 无效，重新登录
//        [[NSNotificationCenter defaultCenter] postNotificationName:kCSUserTokenIllegalNotification
//                                                            object:nil
//                                                          userInfo:@{
//                                                                     kCSUserTokenNotificationUserInfoKeyRequestToContinue:[response.request mutableCopy],
//                                                                     kCSUserTokenNotificationUserInfoKeyManagerToContinue:self
//                                                                     }];
//    } else if ([response.content[@"id"] isEqualToString:@"no_permission_for_this_api"]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kCSUserTokenIllegalNotification
//                                                            object:nil
//                                                          userInfo:@{
//                                                                     kCSUserTokenNotificationUserInfoKeyRequestToContinue:[response.request mutableCopy],
//                                                                     kCSUserTokenNotificationUserInfoKeyManagerToContinue:self
//                                                                     }];
//    } else {
//        // 其他错误
//    }
}

#pragma mark - method for interceptor

/*
 拦截器的功能可以由子类通过继承实现，也可以由其它对象实现,两种做法可以共存
 当两种情况共存的时候，子类重载的方法一定要调用一下super
 然后它们的调用顺序是BaseManager会先调用子类重载的实现，再调用外部interceptor的实现
 
 notes:
 正常情况下，拦截器是通过代理的方式实现的，因此可以不需要以下这些代码
 但是为了将来拓展方便，如果在调用拦截器之前manager又希望自己能够先做一些事情，所以这些方法还是需要能够被继承重载的
 所有重载的方法，都要调用一下super,这样才能保证外部interceptor能够被调到
 这就是decorate pattern
 */
- (BOOL)beforePerformSuccessWithResponse:(CSURLResponse *)response
{
    BOOL result = YES;
    
    self.errorType = CSAPIManagerErrorTypeSuccess;
    if ([self.interceptor respondsToSelector:@selector(manager: beforePerformSuccessWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformSuccessWithResponse:response];
    }
    return result;
}

- (void)afterPerformSuccessWithResponse:(CSURLResponse *)response
{
    if ([self.interceptor respondsToSelector:@selector(manager:afterPerformSuccessWithResponse:)]) {
        [self.interceptor manager:self afterPerformSuccessWithResponse:response];
    }
}

- (BOOL)beforePerformFailWithResponse:(CSURLResponse *)response
{
    BOOL result = YES;
    if ([self.interceptor respondsToSelector:@selector(manager:beforePerformFailWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformFailWithResponse:response];
    }
    return result;
}

- (void)afterPerformFailWithResponse:(CSURLResponse *)response
{
    if ([self.interceptor respondsToSelector:@selector(manager:afterPerformFailWithResponse:)]) {
        [self.interceptor manager:self afterPerformFailWithResponse:response];
    }
}

//只有返回YES才会继续调用API
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params
{
    if ([self.interceptor respondsToSelector:@selector(manager:shouldCallAPIWithParams:)]) {
        return [self.interceptor manager:self shouldCallAPIWithParams:params];
    } else {
        return YES;
    }
}

- (void)afterCallingAPIWithParams:(NSDictionary *)params
{
    if ([self.interceptor respondsToSelector:@selector(manager:afterCallingAPIWithParams:)]) {
        [self.interceptor manager:self afterCallingAPIWithParams:params];
    }
}

#pragma mark - CSAPIManager
- (void)cleanData
{
    [self.cache clean];
    self.fetchedRawData = nil;
    self.errorMessage = nil;
    self.errorType = CSAPIManagerErrorTypeDefault;
}

- (NSString *)schemeName
{
    return @"";
}

- (NSString *)hostName
{
    return @"";
}

- (NSString *)pathName
{
    return @"";
}

- (NSTimeInterval)timeInterval
{
    return 20;
}

- (CSAPIManagerRequestType)requestType
{
    return CSAPIManagerRequestTypeGet;
}

//如果需要在调用API之前额外添加一些参数，比如pageNumber和pageSize之类的就在这里添加
//子类中覆盖这个函数的时候就不需要调用[super reformParams:params]了
- (NSDictionary *)reformParams:(NSDictionary *)params
{
    return params;
}

- (BOOL)shouldCache
{
    return NO;
}

- (NSInteger)cacheCount
{
    return 1000;
}

- (NSTimeInterval)cacheOutdateTimeSeconds
{
    return 60*60*12;
}


#pragma mark - getters and setters
- (CSCache *)cache
{
    if (_cache == nil) {
        _cache = [CSCache sharedInstance];
        [_cache setCacheLimitCount:[self cacheCount]];
    }
    return _cache;
}

- (NSMutableArray *)requestIdList
{
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

#if DEBUG
- (NSMutableDictionary *)stubsDic
{
    if (_stubsDic == nil) {
        _stubsDic = [[NSMutableDictionary alloc] init];
    }
    return _stubsDic;
}
#endif

- (BOOL)isReachable
{
    BOOL isReachability = [self networkAvailable];
    if (!isReachability) {
        self.errorType = CSAPIManagerErrorTypeNoNetWork;
    }
    return isReachability;
}

- (BOOL)networkAvailable
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}

- (BOOL)isLoading
{
    if (self.requestIdList.count == 0) {
        _isLoading = NO;
    }
    return _isLoading;
}

- (BOOL)shouldLoadFromNative
{
    return NO;
}

@end
