/*******************************************************************************
 # File        : MapController.m
 # Project     : ReactiveCocoa
 # Author      : shenghai
 # Created     : 2018/8/22
 # Corporation : 成都
 # Description :
 Description Logs
 -------------------------------------------------------------------------------
 # Date        : Change Date
 # Author      : Change Author
 # Notes       :
 Change Logs
 ******************************************************************************/

#import "MapController.h"

@interface MapController ()

@property (nonatomic, strong) RACSubject *signalA;

@end

@implementation MapController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 配置数据
    [self configData];
    // 配置UI
    [self configUI];
}


- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化UI
- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 初始化数据
- (void)configData {
    [self mapOperation];
}

- (void)mapOperation {
    [[self.signalA map:^id(id value) {
        return [value integerValue] > 10 ? @"max then 10" : @"smaller then 10";
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [self.signalA sendNext:@20];
    [self.signalA sendNext:@5];
    [self.signalA sendCompleted];
    [self.signalA sendNext:@50];
}

- (RACSubject *)signalA {
    if (!_signalA) {
        _signalA = [RACSubject subject];
    }
    return _signalA;
}


@end
