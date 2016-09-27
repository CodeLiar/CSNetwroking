//
//  CSRequestGenerator.m
//  CSNetworking
//
//  Created by Geass on 9/26/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import "CSRequestGenerator.h"
#import <AFNetworking.h>
#import "NSURLRequest+CSNetworkingMethods.h"
#import "CSNetworkingConfiguration.h"

@interface CSRequestGenerator ()

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation CSRequestGenerator

#pragma mark - public methods
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static CSRequestGenerator *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CSRequestGenerator alloc] init];
    });
    return sharedInstance;
}

- (NSURLRequest *)generateGETRequestWithDomainName:(NSString *)domainName requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", domainName, methodName];
    
    [self.httpRequestSerializer setValue:[[NSUUID UUID] UUIDString] forHTTPHeaderField:@"xxxxxxxx"];
    
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:requestParams error:NULL];
    request.requestParams = requestParams;
    return request;
}

- (NSURLRequest *)generatePOSTRequestWithDomainName:(NSString *)domainName requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", domainName, methodName];
    
    [self.httpRequestSerializer setValue:[[NSUUID UUID] UUIDString] forHTTPHeaderField:@"xxxxxxxx"];
    
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:requestParams error:NULL];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:0 error:NULL];
    
    request.requestParams = requestParams;
    return request;
}

- (NSURLRequest *)generatePutRequestWithDomainName:(NSString *)domainName requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", domainName, methodName];
    
    [self.httpRequestSerializer setValue:[[NSUUID UUID] UUIDString] forHTTPHeaderField:@"xxxxxxxx"];
    
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"PUT" URLString:urlString parameters:requestParams error:NULL];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:0 error:NULL];
    request.requestParams = requestParams;
    return request;
}

- (NSURLRequest *)generateDeleteRequestWithDomainName:(NSString *)domainName requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", domainName, methodName];
    
    [self.httpRequestSerializer setValue:[[NSUUID UUID] UUIDString] forHTTPHeaderField:@"xxxxxxxx"];
    
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"DELETE" URLString:urlString parameters:requestParams error:NULL];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:0 error:NULL];
    request.requestParams = requestParams;
    return request;
}

#pragma mark - getters and setters
- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = kCSNetworkingTimeoutSeconds;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}

@end
