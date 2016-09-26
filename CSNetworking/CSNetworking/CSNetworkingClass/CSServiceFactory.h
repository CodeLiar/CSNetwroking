//
//  CSServiceFactory.h
//  CSNetworking
//
//  Created by Geass on 9/26/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSService.h"

@interface CSServiceFactory : NSObject

+ (instancetype)sharedInstance;
- (CSService<CSServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier;

@end
