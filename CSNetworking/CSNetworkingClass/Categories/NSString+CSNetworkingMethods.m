//
//  NSString+CSNetworkingMethods.m
//  CSNetworking
//
//  Created by Geass on 9/26/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>
#import "NSString+CSNetworkingMethods.h"
#import "NSObject+CSNetworkingMethods.h"

@implementation NSString (CSNetworkingMethods)

- (NSString *)CS_md5
{
    NSData* inputData = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char outputData[CC_MD5_DIGEST_LENGTH];
    CC_MD5([inputData bytes], (unsigned int)[inputData length], outputData);
    
    NSMutableString* hashStr = [NSMutableString string];
    int i = 0;
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; ++i)
        [hashStr appendFormat:@"%02x", outputData[i]];
    
    return hashStr;
}

@end
