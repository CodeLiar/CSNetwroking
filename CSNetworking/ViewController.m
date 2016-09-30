//
//  ViewController.m
//  CSNetworking
//
//  Created by Geass on 9/23/16.
//  Copyright © 2016 ContinuedStory. All rights reserved.
//

#import "ViewController.h"
#import "TestAPIManager.h"
#import <OHHTTPStubs.h>


@interface ViewController () <CSAPIManagerCallBackDelegate, CSAPIManagerParamSource>

@property (nonatomic, strong) NSMutableDictionary *dic;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dic  = [NSMutableDictionary dictionary];
    [self requestAction:nil];
}

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

- (IBAction)pushAction:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ViewController *vc = [story instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)requestAction:(id)sender {
    for (NSInteger i=0; i<1; i++) {
        TestAPIManager *manager = [[TestAPIManager alloc] init];
        manager.delegate = self;
        manager.paramSource = self;
        [manager loadStubData];
        [manager loadData];
    }
}

- (NSDictionary *)paramsForAPI:(__kindof CSAPIBaseManager *)manager
{
    return @{
             @"location": [NSString stringWithFormat:@"%@,%@", @(121.454290), @(31.228000)],
             @"output": @"json",
             @"key": @"384ecc4559ffc3b9ed1f81076c5f8424"
             };
}

- (void)managerCallAPIDidSuccess:(__kindof CSAPIBaseManager *)manager
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", [manager fetchDataWithReformer:nil]);
    [NSArray arrayWithObject:self.dic];
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [wSelf asyncMethod];
    });
}

- (void)asyncMethod
{
    for (int i = 0; i < 10; i++) {
        sleep(1);
    }
}

- (void)managerCallAPIDidFailed:(__kindof CSAPIBaseManager *)manager
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%ld", (long)manager.errorType);
    [NSArray arrayWithObject:self.dic];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 10; i++) {
            sleep(1);
        }
    });
}

@end
