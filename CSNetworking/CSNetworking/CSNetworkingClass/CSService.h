//
//  CSService.h
//  CSNetworking
//
//  Created by Geass on 9/26/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSNetworkingConfiguration.h"

NS_ASSUME_NONNULL_BEGIN
// 所有CSService的派生类都要符合这个protocol
@protocol CSServiceProtocol <NSObject>

@property (nonatomic, readonly) BOOL isOnline;

@property (nonatomic, readonly) NSString *offlineAPIBaseUrl;
@property (nonatomic, readonly) NSString *onlineAPIBaseUrl;

@property (nonatomic, readonly) NSString *offlineAPIVersion;
@property (nonatomic, readonly) NSString *onlineAPIVersion;

@property (nonatomic, readonly) NSString *onlinePublicKey;
@property (nonatomic, readonly) NSString *offlinePublicKey;

@property (nonatomic, readonly) NSString *onlinePrivateKey;
@property (nonatomic, readonly) NSString *offlinePrivateKey;

@end

@interface CSService : NSObject

@property (nonatomic, strong, readonly) NSString *publicKey;
@property (nonatomic, strong, readonly) NSString *privateKey;
@property (nonatomic, strong, readonly) NSString *apiBaseUrl;
@property (nonatomic, strong, readonly) NSString *apiVersion;

@property (nonatomic, weak) id<CSServiceProtocol> child;

@end
NS_ASSUME_NONNULL_END
