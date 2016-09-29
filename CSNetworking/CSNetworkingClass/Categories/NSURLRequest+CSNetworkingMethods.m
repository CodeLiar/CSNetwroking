//
//  NSURLRequest+CSNetworkingMethods.m
//  CSNetworking
//
//  Created by Geass on 9/26/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import "NSURLRequest+CSNetworkingMethods.h"
#import <objc/runtime.h>

static void *CSNetworkingRequestParams;

@implementation NSURLRequest (CSNetworkingMethods)

- (void)setRequestParams:(NSDictionary *)requestParams
{
    objc_setAssociatedObject(self, &CSNetworkingRequestParams, requestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)requestParams
{
    return objc_getAssociatedObject(self, &CSNetworkingRequestParams);
}

@end
