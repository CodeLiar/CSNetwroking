//
//  UIDevice+CSNetworkingMethods.h
//  CSNetworking
//
//  Created by Geass on 9/26/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (CSNetworkingMethods)

/*
 * @method uuid
 * @description apple identifier support iOS6 and iOS5 below
 */

- (NSString *)CS_uuid;
- (NSString *)CS_udid;
- (NSString *)CS_macaddress;
- (NSString *)CS_macaddressMD5;
- (NSString *)CS_machineType;
- (NSString *)CS_ostype;//显示“ios6，ios5”，只显示大版本号
- (NSString *)CS_createUUID;

@end
