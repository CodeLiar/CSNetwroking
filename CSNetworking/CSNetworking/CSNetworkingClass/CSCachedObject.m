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
    return timeInterval > kCSCacheOutdateTimeSeconds;
}

- (void)setContent:(NSData *)content
{
    _content = [content copy];
    self.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];
}


#pragma mark - life cycle

- (instancetype)initWithContent:(NSData *)content
{
    self = [super init];
    if (self) {
        self.content = content;
    }
    return self;
}


#pragma mark - public method

- (void)updateContent:(NSData *)content
{
    self.content = content;
}

@end
