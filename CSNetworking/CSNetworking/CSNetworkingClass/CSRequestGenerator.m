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
    
    AFHTTPRequestSerializer *serializer = [self httpRequestSerializerWithTimeoutInterval:20];
    
    [serializer setValue:[[NSUUID UUID] UUIDString] forHTTPHeaderField:@"xxxxxxxx"];
    
    NSMutableURLRequest *request = [serializer requestWithMethod:@"GET" URLString:urlString parameters:requestParams error:NULL];
    request.requestParams = requestParams;
    return request;
}

- (NSURLRequest *)generatePOSTRequestWithDomainName:(NSString *)domainName requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", domainName, methodName];
    
    AFHTTPRequestSerializer *serializer = [self httpRequestSerializerWithTimeoutInterval:20];
    [serializer setValue:[[NSUUID UUID] UUIDString] forHTTPHeaderField:@"xxxxxxxx"];
    
    NSMutableURLRequest *request = [serializer requestWithMethod:@"POST" URLString:urlString parameters:requestParams error:NULL];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:0 error:NULL];
    
    request.requestParams = requestParams;
    return request;
}

- (NSURLRequest *)generatePutRequestWithDomainName:(NSString *)domainName requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", domainName, methodName];
    
    AFHTTPRequestSerializer *serializer = [self httpRequestSerializerWithTimeoutInterval:20];
    [serializer setValue:[[NSUUID UUID] UUIDString] forHTTPHeaderField:@"xxxxxxxx"];
    
    NSMutableURLRequest *request = [serializer requestWithMethod:@"PUT" URLString:urlString parameters:requestParams error:NULL];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:0 error:NULL];
    request.requestParams = requestParams;
    return request;
}

- (NSURLRequest *)generateDeleteRequestWithDomainName:(NSString *)domainName requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", domainName, methodName];
    
    AFHTTPRequestSerializer *serializer = [self httpRequestSerializerWithTimeoutInterval:20];
    [serializer setValue:[[NSUUID UUID] UUIDString] forHTTPHeaderField:@"xxxxxxxx"];
    
    NSMutableURLRequest *request = [serializer requestWithMethod:@"DELETE" URLString:urlString parameters:requestParams error:NULL];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:0 error:NULL];
    request.requestParams = requestParams;
    return request;
}

#pragma mark - private 

- (AFHTTPRequestSerializer *)httpRequestSerializerWithTimeoutInterval:(NSTimeInterval)timeInterval
{
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    serializer.timeoutInterval = timeInterval;
    serializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    return serializer;
}

@end
