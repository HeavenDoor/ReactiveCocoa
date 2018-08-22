/*******************************************************************************
 # File        : CombineLatestController.m
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

#import "CombineLatestController.h"

@interface CombineLatestController ()
@property (nonatomic, strong) RACSubject *signalA;

@property (nonatomic, strong) RACSubject *signalB;
@end

@implementation CombineLatestController

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

//操作过程 http://neilpa.me/rac-marbles/#combineLatest
#pragma mark - 初始化数据
- (void)configData {
    self.signalA = [RACSubject subject];
    self.signalB = [RACSubject subject];
    
    //[self combineLatestTest];
    [self reduceTest];
}

/**
将多个信号合并起来，并且拿到各个信号的最新的值,
 必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号。
 之后没有一个信号改变会结合没有改变信号的最后一个值发出
 combineLatest 可以理解为结合最后一次变化的数据
 
 */
- (void)combineLatestTest {
    [self.signalA combineLatestWith:self.signalB];
    
//    [RACSignal combineLatest:@[self.signalA, self.signalB] reduce:^id(NSString *aText, NSString *bText){
//        return [RACSignal empty];
//    }];
    
    [[RACSignal combineLatest:@[self.signalA, self.signalB]] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [self.signalA sendNext:@" 1 "];
    [self.signalB sendNext:@" 2 "];
    [self.signalB sendNext:@" 3 "];
    [self.signalA sendNext:@" 4 "];
    [self.signalB sendNext:@" 5 "];
    [self.signalA sendNext:@" 6 "];
    [self.signalA sendNext:@" 7 "];
    [self.signalA sendNext:@" 8 "];
    [self.signalB sendNext:@" 9 "];
    [self.signalB sendNext:@" 10 "];
}

- (void)reduceTest {
    [[RACSignal combineLatest:@[self.signalA, self.signalB] reduce:^id(NSString *aText, NSString *bText){
        return [NSString stringWithFormat:@"%@ - %@", aText, bText];
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [self.signalA sendNext:@" 1 "];
    [self.signalB sendNext:@" 2 "];
    [self.signalB sendNext:@" 3 "];
    [self.signalA sendNext:@" 4 "];
    [self.signalB sendNext:@" 5 "];
    [self.signalA sendNext:@" 6 "];
    [self.signalA sendNext:@" 7 "];
    [self.signalA sendNext:@" 8 "];
    [self.signalB sendNext:@" 9 "];
    [self.signalB sendNext:@" 10 "];
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
@end
