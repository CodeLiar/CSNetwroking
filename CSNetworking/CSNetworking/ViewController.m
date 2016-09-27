//
//  ViewController.m
//  CSNetworking
//
//  Created by Geass on 9/23/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import "ViewController.h"
#import "TestAPIManager.h"

@interface ViewController () <CSAPIManagerCallBackDelegate, CSAPIManagerParamSource>

@property (nonatomic, strong) TestAPIManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)requestAction:(id)sender {
    for (NSInteger i=0; i<10; i++) {
        [self.manager loadData];
    }
}

- (NSDictionary *)paramsForAPI:(__kindof CSAPIBaseManager *)manager
{
    return @{
             @"kTestAPIManagerParamsKeyLatitude":@(31.228000),
             @"kTestAPIManagerParamsKeyLongitude":@(121.454290)
             };;
}

- (void)managerCallAPIDidSuccess:(__kindof CSAPIBaseManager *)manager
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", [manager fetchDataWithReformer:nil]);
}

- (void)managerCallAPIDidFailed:(__kindof CSAPIBaseManager *)manager
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", [manager fetchDataWithReformer:nil]);
}

- (TestAPIManager *)manager
{
    if (!_manager) {
        _manager = [[TestAPIManager alloc] init];
        _manager.delegate = self;
        _manager.paramSource = self;
    }
    return _manager;
}

@end
