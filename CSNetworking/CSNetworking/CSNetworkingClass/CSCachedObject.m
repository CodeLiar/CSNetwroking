//
//  CSCachedObject.m
//  CSNetworking
//
//  Created by Geass on 9/26/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import "CSCachedObject.h"
#import "CSNetworkingConfiguration.h"

@interface CSCachedObject ()

@property (nonatomic, copy) NSData *content;
@property (nonatomic, copy) NSDate *lastUpdateTime;

@end

@implementation CSCachedObject


#pragma marm - getters and setters

- (BOOL)isEmpty
{
    return nil == self.content;
}

- (BOOL)isOutdataed
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
    return timeInterval > self.cacheOutdateTimeSeconds;
}

- (void)setContent:(NSData *)content
{
    _content = [content copy];
    self.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];
}


#pragma mark - life cycle

- (instancetype)initWithContent:(NSData *)content cacheOutdateTimeSeconds:(NSInteger)cacheOutdateTimeSeconds
{
    self = [super init];
    if (self) {
        self.content = content;
        self.cacheOutdateTimeSeconds = cacheOutdateTimeSeconds;
    }
    return self;
}


#pragma mark - public method

- (void)updateContent:(NSData *)content cacheOutdateTimeSeconds:(NSInteger)cacheOutdateTimeSeconds
{
    self.content = content;
    self.cacheOutdateTimeSeconds = cacheOutdateTimeSeconds;
}

@end
