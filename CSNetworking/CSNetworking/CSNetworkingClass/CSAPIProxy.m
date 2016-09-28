//
//  CSAPIProxy.m
//  CSNetworking
//
//  Created by Geass on 9/26/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import "CSAPIProxy.h"
#import <AFNetworking.h>
#import "CSRequestGenerator.h"
#import "CSLogger.h"

@interface CSAPIProxy ()

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;

//AFNetworking stuff
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end
@implementation CSAPIProxy

#pragma mark - getters and setters
- (NSMutableDictionary *)dispatchTable
{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFHTTPSessionManager *)sessionManager
{
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    return _sessionManager;
}

#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static CSAPIProxy *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CSAPIProxy alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods
- (NSInteger)callGETWithParams:(NSDictionary *)params domainName:(NSString *)domainName methodName:(NSString *)methodName success:(nullable CSCallback)success fail:(nullable CSCallback)fail
{
    NSURLRequest *request = [[CSRequestGenerator sharedInstance] generateGETRequestWithDomainName:domainName requestParams:params methodName:methodName];
    NSNumber *requestId = [self callAPIWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callPOSTWithParams:(NSDictionary *)params domainName:(NSString *)domainName methodName:(NSString *)methodName success:(nullable CSCallback)success fail:(nullable CSCallback)fail
{
    NSURLRequest *request = [[CSRequestGenerator sharedInstance] generatePOSTRequestWithDomainName:domainName requestParams:params methodName:methodName];
    NSNumber *requestId = [self callAPIWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callPUTWithParams:(NSDictionary *)params domainName:(NSString *)domainName methodName:(NSString *)methodName success:(nullable CSCallback)success fail:(nullable CSCallback)fail
{
    NSURLRequest *request = [[CSRequestGenerator sharedInstance] generatePutRequestWithDomainName:domainName requestParams:params methodName:methodName];
    NSNumber *requestId = [self callAPIWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callDELETEWithParams:(NSDictionary *)params domainName:(NSString *)domainName methodName:(NSString *)methodName success:(nullable CSCallback)success fail:(nullable CSCallback)fail
{
    NSURLRequest *request = [[CSRequestGenerator sharedInstance] generateDeleteRequestWithDomainName:domainName requestParams:params methodName:methodName];
    NSNumber *requestId = [self callAPIWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID
{
    NSURLSessionDataTask *requestOperation = self.dispatchTable[requestID];
    [requestOperation cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList
{
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

/** 这个函数存在的意义在于，如果将来要把AFNetworking换掉，只要修改这个函数的实现即可。 */
- (NSNumber *)callAPIWithRequest:(NSURLRequest *)request success:(nullable CSCallback)success fail:(nullable CSCallback)fail
{
    
    NSLog(@"\n==================================\n\nRequest Start: \n\n %@\n\n==================================", request.URL);
    
    // 跑到这里的block的时候，就已经是主线程了。
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.dispatchTable removeObjectForKey:requestID];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSData *responseData = responseObject;
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        if (error) {
            [CSLogger logDebugInfoWithResponse:httpResponse
                                responseString:responseString
                                       request:request
                                         error:error];
            CSURLResponse *CTResponse = [[CSURLResponse alloc] initWithResponseString:responseString requestId:requestID request:request responseData:responseData error:error];
            fail?fail(CTResponse):nil;
        } else {
            // 检查http response是否成立。
            [CSLogger logDebugInfoWithResponse:httpResponse
                                responseString:responseString
                                       request:request
                                         error:NULL];
            CSURLResponse *CTResponse = [[CSURLResponse alloc] initWithResponseString:responseString requestId:requestID request:request responseData:responseData status:CSURLResponseStatusSuccess];
            success?success(CTResponse):nil;
        }
    }];
    
    NSNumber *requestId = @([dataTask taskIdentifier]);
    
    self.dispatchTable[requestId] = dataTask;
    [dataTask resume];
    
    return requestId;
}

@end
