//
//  CSLocationManager.h
//  yili
//
//  Created by casa on 15/10/12.
//  Copyright © 2015年 Beauty Sight Network Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSUInteger, CSLocationManagerLocationServiceStatus) {
    CSLocationManagerLocationServiceStatusDefault,               //默认状态
    CSLocationManagerLocationServiceStatusOK,                    //定位功能正常
    CSLocationManagerLocationServiceStatusUnknownError,          //未知错误
    CSLocationManagerLocationServiceStatusUnAvailable,           //定位功能关掉了
    CSLocationManagerLocationServiceStatusNoAuthorization,       //定位功能打开，但是用户不允许使用定位
    CSLocationManagerLocationServiceStatusNoNetwork,             //没有网络
    CSLocationManagerLocationServiceStatusNotDetermined          //用户还没做出是否要允许应用使用定位功能的决定，第一次安装应用的时候会提示用户做出是否允许使用定位功能的决定
};

typedef NS_ENUM(NSUInteger, CSLocationManagerLocationResult) {
    CSLocationManagerLocationResultDefault,              //默认状态
    CSLocationManagerLocationResultLocating,             //定位中
    CSLocationManagerLocationResultSuccess,              //定位成功
    CSLocationManagerLocationResultFail,                 //定位失败
    CSLocationManagerLocationResultParamsError,          //调用API的参数错了
    CSLocationManagerLocationResultTimeout,              //超时
    CSLocationManagerLocationResultNoNetwork,            //没有网络
    CSLocationManagerLocationResultNoContent             //API没返回数据或返回数据是错的
};

NS_ASSUME_NONNULL_BEGIN

@interface CSLocationManager : NSObject

@property (nonatomic, assign, readonly) CSLocationManagerLocationResult locationResult;
@property (nonatomic, assign,readonly) CSLocationManagerLocationServiceStatus locationStatus;
@property (nonatomic, copy, readonly) CLLocation *currentLocation;

+ (instancetype)sharedInstance;

- (void)startLocation;
- (void)stopLocation;
- (void)restartLocation;

@end

NS_ASSUME_NONNULL_END
