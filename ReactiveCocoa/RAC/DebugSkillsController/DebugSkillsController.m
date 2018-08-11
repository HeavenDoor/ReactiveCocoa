/*******************************************************************************
 # File        : DebugSkillsController.m
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

#import "DebugSkillsController.h"

@interface DebugSkillsController ()

@end

@implementation DebugSkillsController

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
    RACSignal *signal = [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        /** 这里要注意 sendError 和 sendCompleted不可能同时发生 一旦sendError，sendCompleted不会再调用了 */
        NSError *error = [[NSError alloc] initWithDomain:@"shenh" code:12345 userInfo:@{@"23":@"rhjk"}];
        [subscriber sendError:error];
        
        [subscriber sendCompleted];
        RACDisposable *disposable = [RACDisposable disposableWithBlock:^{
            NSLog(@"dispose in didSubscribe block");
        }];
        return disposable;
    }] setNameWithFormat:@"%@ Line %d RACSignal signal", [self class], __LINE__] logAll]; // 1
    
    RACDisposable *disposable = [[[[signal logNext] logError] logCompleted] subscribeNext:^(id x) { // 2
        NSLog(@"next: %@", x);
    } error:^(NSError *error) {
        NSLog(@"error: %@", error);
    } completed:^{
        NSLog(@"completed");
    }];
    [disposable dispose];
}


- (void)extension {
    RACSignal *signal = [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        /** 这里要注意 sendError 和 sendCompleted不可能同时发生 一旦sendError，sendCompleted不会再调用了 */
        NSError *error = [[NSError alloc] initWithDomain:@"shenh" code:12345 userInfo:@{@"23":@"rhjk"}];
        [subscriber sendError:error];
        
        //[subscriber sendCompleted];
        RACDisposable *disposable = [RACDisposable disposableWithBlock:^{
            NSLog(@"dispose in didSubscribe block");
        }];
        return disposable;
    }] setNameWithFormat:@"%@ Line %d RACSignal signal", [self class], __LINE__] logAll];
    
    RACDisposable *disposable = [[[[[signal logNext] logError] logCompleted] catchTo:[RACSignal return:@"error"]] subscribeNext:^(id x) {
        NSLog(@"next: %@", x);
    } error:^(NSError *error) {
        NSLog(@"error: %@", error);
    } completed:^{
        NSLog(@"completed");
    }];
    [disposable dispose];
}

@end
