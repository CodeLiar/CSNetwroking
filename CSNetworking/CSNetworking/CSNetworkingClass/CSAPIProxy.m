//
//  CSAPIProxy.m
//  CSNetworking
//
//  Created by Geass on 9/26/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import "CSAPIProxy.h"
#import <AFNetworking.h>
#import "CSLogger.h"
#import "CSAPIBaseManager.h"
#import "NSURLRequest+CSNetworkingMethods.h"

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

- (NSInteger)callAPIWithManager:(CSAPIBaseManager *)manager params:(NSDictionary *)params success:(CSCallback)success fail:(CSCallback)fail
{
    NSURLRequest *request = [self generateRequestWithAPIManager:manager params:params];
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
                             
- (NSURLRequest *)generateRequestWithAPIManager:(CSAPIBaseManager *)manager params:(NSDictionary *)params
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", manager.domainName, manager.methodName];
    
    AFHTTPRequestSerializer *serializer = [self httpRequestSerializerWithAPIManager:manager];
    
    NSMutableURLRequest *request = nil;
    switch (manager.requestType) {
        case CSAPIManagerRequestTypeGet:
            request = [serializer requestWithMethod:@"GET" URLString:urlString parameters:params error:NULL];
            request.requestParams = params;
            break;
        case CSAPIManagerRequestTypePost:
            request = [serializer requestWithMethod:@"POST" URLString:urlString parameters:params error:NULL];
            request.HTTPBody = [NSJSONSerialization dataWithJSONObject:params options:0 error:NULL];
            request.requestParams = params;
            break;
        case CSAPIManagerRequestTypePut:
            request = [serializer requestWithMethod:@"PUT" URLString:urlString parameters:params error:NULL];
            request.HTTPBody = [NSJSONSerialization dataWithJSONObject:params options:0 error:NULL];
            request.requestParams = params;
            break;
        case CSAPIManagerRequestTypeDelete:
            request = [serializer requestWithMethod:@"DELETE" URLString:urlString parameters:params error:NULL];
            request.HTTPBody = [NSJSONSerialization dataWithJSONObject:params options:0 error:NULL];
            request.requestParams = params;
            break;
            
        default:
            break;
    }
    
    
    return request;
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
            CSURLResponse *CSResponse = [[CSURLResponse alloc] initWithResponseString:responseString requestId:requestID request:request responseData:responseData error:error];
            fail?fail(CSResponse):nil;
        } else {
            // 检查http response是否成立。
            [CSLogger logDebugInfoWithResponse:httpResponse
                                responseString:responseString
                                       request:request
                                         error:NULL];
            CSURLResponse *CSResponse = [[CSURLResponse alloc] initWithResponseString:responseString requestId:requestID request:request responseData:responseData status:CSURLResponseStatusSuccess];
            success?success(CSResponse):nil;
        }
    }];
    
    NSNumber *requestId = @([dataTask taskIdentifier]);
    
    self.dispatchTable[requestId] = dataTask;
    [dataTask resume];
    
    return requestId;
}

#pragma mark - private

- (AFHTTPRequestSerializer *)httpRequestSerializerWithAPIManager:(CSAPIBaseManager *)manager
{
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    serializer.timeoutInterval = manager.timeInterval;
    serializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    [serializer setValue:[[NSUUID UUID] UUIDString] forHTTPHeaderField:@"xxxxxxxx"];
    return serializer;
}

@end
