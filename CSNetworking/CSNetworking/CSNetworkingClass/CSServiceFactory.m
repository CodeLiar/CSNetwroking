//
//  CSServiceFactory.m
//  CSNetworking
//
//  Created by Geass on 9/26/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import "CSServiceFactory.h"
#import "LDService.h"

// service name list
NSString * const kCTServiceGDMapV3 = @"kCTServiceGDMapV3";

@interface CSServiceFactory ()

@property (nonatomic, strong) NSMutableDictionary *serviceStorage;

@end

@implementation CSServiceFactory


#pragma mark - getters and setters
- (NSMutableDictionary *)serviceStorage
{
    if (_serviceStorage == nil) {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}

#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static CSServiceFactory *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CSServiceFactory alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods
- (CSService<CSServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier
{
    if (self.serviceStorage[identifier] == nil) {
        self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
    }
    return self.serviceStorage[identifier];
}

#pragma mark - private methods
- (CSService<CSServiceProtocol> *)newServiceWithIdentifier:(NSString *)identifier
{
    if ([identifier isEqualToString:kCTServiceGDMapV3]) {
        return [[LDService alloc] init];
    }
    
    return nil;
}

@end
