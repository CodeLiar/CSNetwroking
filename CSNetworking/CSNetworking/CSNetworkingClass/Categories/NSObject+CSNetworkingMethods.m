//
//  NSObject+CSNetworkingMethods.m
//  CSNetworking
//
//  Created by Geass on 9/26/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import "NSObject+CSNetworkingMethods.h"

@implementation NSObject (CSNetworkingMethods)

- (id)CS_defaultValue:(id)defaultData
{
    if (![defaultData isKindOfClass:[self class]]) {
        return defaultData;
    }
    
    if ([self CS_isEmptyObject]) {
        return defaultData;
    }
    
    return self;
}

- (BOOL)CS_isEmptyObject
{
    return self == nil || [self isKindOfClass:[NSNull class]] || ([self respondsToSelector:@selector(length)] && [(NSString *)self length] == 0) || ([self respondsToSelector:@selector(count)] && [(NSArray *)self count] == 0);
}

@end
