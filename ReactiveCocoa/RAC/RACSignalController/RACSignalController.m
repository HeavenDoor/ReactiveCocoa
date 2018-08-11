/*******************************************************************************
 # File        : RACSignalController.m
 # Project     : ReactiveCocoa
 # Author      : shenghai
 # Created     : 2018/8/11
 # Corporation : 成都
 # Description :
 Description Logs
 -------------------------------------------------------------------------------
 # Date        : Change Date
 # Author      : Change Author
 # Notes       :
 Change Logs
 ******************************************************************************/

#import "RACSignalController.h"

@interface RACSignalController ()

@end

@implementation RACSignalController

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
    
}

#pragma mark - 初始化数据
- (void)configData {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        RACDisposable *disposable = [RACDisposable disposableWithBlock:^{
            NSLog(@"dispose in didSubscribe block");
        }];
        return disposable;
    }];
    
    RACDisposable *disposable = [signal subscribeNext:^(id x) {
        
    } error:^(NSError *error) {
        
    } completed:^{
        
    }];
    [disposable dispose];
}


@end
