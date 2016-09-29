//
//  NSArray+CSNetworkingMethods.h
//  CSNetworking
//
//  Created by Geass on 9/26/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (CSNetworkingMethods)

/// 字母排序之后形成的参数字符串
- (NSString *)CS_paramsString;
/// 数组变json，返回格式有助于打印，不适用于js调用
- (NSString *)CS_jsonString;

@end

NS_ASSUME_NONNULL_END
