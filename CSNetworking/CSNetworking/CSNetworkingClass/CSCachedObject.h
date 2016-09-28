//
//  CSCachedObject.h
//  CSNetworking
//
//  Created by Geass on 9/26/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSCachedObject : NSObject

@property (nonatomic, copy, readonly) NSData *content;
@property (nonatomic, copy, readonly) NSDate *lastUpdateTime;
@property (nonatomic, assign) NSInteger cacheOutdateTimeSeconds;

@property (nonatomic, assign, readonly) BOOL isOutdataed;
@property (nonatomic, assign, readonly) BOOL isEmpty;

- (instancetype)initWithContent:(NSData *)content cacheOutdateTimeSeconds:(NSInteger)cacheOutdateTimeSeconds;
- (void)updateContent:(NSData *)content cacheOutdateTimeSeconds:(NSInteger)cacheOutdateTimeSeconds;

@end

NS_ASSUME_NONNULL_END
