/*******************************************************************************
 # File        : MergeController.m
 # Project     : ReactiveCocoa
 # Author      : shenghai
 # Created     : 2018/8/20
 # Corporation : 成都
 # Description : Merge操作  多个信号合并成一个信号，任何一个信号有新值就会调用
 Description Logs
 -------------------------------------------------------------------------------
 # Date        : Change Date
 # Author      : Change Author
 # Notes       :
 Change Logs
 ******************************************************************************/

#import "MergeController.h"

@interface MergeController ()

@property (nonatomic, strong) RACSubject *signalA;

@property (nonatomic, strong) RACSubject *signalB;

@property (nonatomic, strong) RACSubject *signalC;

@end

@implementation MergeController

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
    self.signalA = [RACSubject subject];
    self.signalB = [RACSubject subject];
    self.signalC = [RACSubject subject];
    
    //[self mergeWithError];
    //[self mergeSuccess];
    [self mergeComPlete];
}



#pragma mark - 合并过程出错
- (void)mergeWithError {
    RACSignal *mergeSignal = [RACSignal merge:@[self.signalA, self.signalB, self.signalC]];
    // 订阅信号
    [mergeSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    } error:^(NSError *error) {
        NSLog(@"merge过程因为收到错误中断 error： %@", error);
    }];
    // 发送信号---交换位置则数据结果顺序也会交换
    NSError *error = [[NSError alloc] initWithDomain:@"shenh" code:12345 userInfo:@{@"23":@"rhjk"}];
    
//    [self.signalA sendNext:@"上部分"];
//    [self.signalB sendNext:@"下部分"];
//    [self.signalC sendError:error];
    
    /** 一旦merge过程出现错误，后面的过程不会继续执行了 */
    [self.signalC sendError:error];
    [self.signalA sendNext:@"上部分"];
    [self.signalB sendNext:@"下部分"];
    
}

#pragma mark - 合并过程成功
- (void)mergeSuccess {
    RACSignal *mergeSignal = [RACSignal merge:@[self.signalA, self.signalB, self.signalC]];
    // 订阅信号
    [mergeSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
//    [self.signalC sendNext:@"开始"];
//    [self.signalA sendNext:@"上部分"];
//    [self.signalB sendNext:@"下部分"];

    /** 发送的顺序决定接收顺序 */
    [self.signalA sendNext:@"上部分"];
    [self.signalB sendNext:@"下部分"];
    [self.signalC sendNext:@"开始"];
}


#pragma mark - 合并过程完成
- (void)mergeComPlete {
    RACSignal *mergeSignal = [RACSignal merge:@[self.signalA, self.signalB, self.signalC]];
    // 订阅信号
    [mergeSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    } completed:^{
        NSLog(@"==== 完成");
    }];
    
    [self.signalA sendNext:@"上部分"];
    [self.signalB sendNext:@"下部分"];
    
    [self.signalA sendCompleted];
    [self.signalB sendCompleted];
    
    /** 当所有信号都调用sendCompleted之后 completed才会执行 */
    //[self.signalC sendCompleted];

}


- (RACSubject *)signalA {
    if (!_signalA) {
        _signalA = [RACSubject subject];
    }
    return _signalA;
}

- (RACSubject *)signalB {
    if (!_signalB) {
        _signalB = [RACSubject subject];
    }
    return _signalB;
}

- (RACSubject *)signalC {
    if (!_signalC) {
        _signalC = [RACSubject subject];
    }
    return _signalC;
}

@end
