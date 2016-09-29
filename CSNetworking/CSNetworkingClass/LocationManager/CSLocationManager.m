//
//  CSLocationManager.m
//  yili
//
//  Created by casa on 15/10/12.
//  Copyright © 2015年 Beauty Sight Network Technology Co.,Ltd. All rights reserved.
//

#import "CSLocationManager.h"

@interface CSLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, assign, readwrite) CSLocationManagerLocationResult locationResult;
@property (nonatomic, assign, readwrite) CSLocationManagerLocationServiceStatus locationStatus;
@property (nonatomic, copy, readwrite) CLLocation *currentLocation;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation CSLocationManager

+ (instancetype)sharedInstance
{
    static CSLocationManager *locationManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationManager = [[CSLocationManager alloc] init];
    });
    return locationManager;
}

- (void)startLocation
{
    if ([self checkLocationStatus]) {
        self.locationResult = CSLocationManagerLocationResultLocating;
        [self.locationManager startUpdatingLocation];
    } else {
        [self failedLocationWithResultType:CSLocationManagerLocationResultFail statusType:self.locationStatus];
    }
}

- (void)stopLocation
{
    if ([self checkLocationStatus]) {
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)restartLocation
{
    [self stopLocation];
    [self startLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [manager.location copy];
    NSLog(@"Current location is %@", self.currentLocation);
    [self stopLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //如果用户还没选择是否允许定位，则不认为是定位失败
    if (self.locationStatus == CSLocationManagerLocationServiceStatusNotDetermined) {
        return;
    }
    
    //如果正在定位中，那么也不会通知到外面
    if (self.locationResult == CSLocationManagerLocationResultLocating) {
        return;
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.locationStatus = CSLocationManagerLocationServiceStatusOK;
        [self restartLocation];
    } else {
        if (self.locationStatus != CSLocationManagerLocationServiceStatusNotDetermined) {
            [self failedLocationWithResultType:CSLocationManagerLocationResultDefault statusType:CSLocationManagerLocationServiceStatusNoAuthorization];
        } else {
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager startUpdatingLocation];
        }
    }
}

#pragma mark - private methods
- (void)failedLocationWithResultType:(CSLocationManagerLocationResult)result statusType:(CSLocationManagerLocationServiceStatus)status
{
    self.locationResult = result;
    self.locationStatus = status;
}

- (BOOL)checkLocationStatus;
{
    BOOL result = NO;
    BOOL serviceEnable = [self locationServiceEnabled];
    CSLocationManagerLocationServiceStatus authorizationStatus = [self locationServiceStatus];
    if (authorizationStatus == CSLocationManagerLocationServiceStatusOK && serviceEnable) {
        result = YES;
    }else if (authorizationStatus == CSLocationManagerLocationServiceStatusNotDetermined) {
        result = YES;
    }else{
        result = NO;
    }
    
    if (serviceEnable && result) {
        result = YES;
    }else{
        result = NO;
    }
    
    if (result == NO) {
        [self failedLocationWithResultType:CSLocationManagerLocationResultFail statusType:self.locationStatus];
    }
    
    return result;
}

- (BOOL)locationServiceEnabled
{
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationStatus = CSLocationManagerLocationServiceStatusOK;
        return YES;
    } else {
        self.locationStatus = CSLocationManagerLocationServiceStatusUnknownError;
        return NO;
    }
}

- (CSLocationManagerLocationServiceStatus)locationServiceStatus
{
    self.locationStatus = CSLocationManagerLocationServiceStatusUnknownError;
    BOOL serviceEnable = [CLLocationManager locationServicesEnabled];
    if (serviceEnable) {
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        switch (authorizationStatus) {
            case kCLAuthorizationStatusNotDetermined:
                self.locationStatus = CSLocationManagerLocationServiceStatusNotDetermined;
                break;
                
            case kCLAuthorizationStatusAuthorizedAlways :
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                self.locationStatus = CSLocationManagerLocationServiceStatusOK;
                break;
                
            case kCLAuthorizationStatusDenied:
                self.locationStatus = CSLocationManagerLocationServiceStatusNoAuthorization;
                break;
                
            default:
                break;
        }
    } else {
        self.locationStatus = CSLocationManagerLocationServiceStatusUnAvailable;
    }
    return self.locationStatus;
}

#pragma mark - getters and setters
- (CLLocationManager *)locationManager
{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}

@end
