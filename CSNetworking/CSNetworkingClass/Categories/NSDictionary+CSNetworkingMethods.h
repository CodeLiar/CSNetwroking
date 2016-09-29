//
//  NSDictionary+CSNetworkingMethods.h
//  CSNetworking
//
//  Created by Geass on 9/26/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CSNetworkingMethods)

/// 字符串前面是没有问号的，如果用于POST，那就不用加问号，如果用于GET，就要加个问号
- (NSString *)CS_urlParamsStringSignature:(BOOL)isForSignature;
/// 字典变json，有助于log，无法js调用
- (NSString *)CS_jsonString;
/// 转义参数
- (NSArray *)CS_transformedUrlParamsArraySignature:(BOOL)isForSignature;

@end
