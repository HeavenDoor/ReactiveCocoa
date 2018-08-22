/*******************************************************************************
 # File        : ConcatController.m
 # Project     : ReactiveCocoa
 # Author      : shenghai
 # Created     : 2018/8/20
 # Corporation : 成都
 # Description :
 Description Logs
 -------------------------------------------------------------------------------
 # Date        : Change Date
 # Author      : Change Author
 # Notes       :
 Change Logs
 ******************************************************************************/

#import "ConcatController.h"

@interface ConcatController ()
@property (nonatomic, strong) RACSubject *signalA;

@property (nonatomic, strong) RACSubject *signalB;

@property (nonatomic, strong) RACSubject *signalC;
@end

@implementation ConcatController

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
    
    //[self test1];
    
    [self test2];
}

- (void)test1 {
    // 订阅拼接的信号，不需要单独订阅signalA，signalB
    // 使用需求：有两部分数据：想让上部分先执行，完了之后再让下部分执行
    // 按顺序去链接
    // 第一个信号必须要调用sendCompleted
    // 所有信号都发送sendCompleted后 才会调用completed回调
    
    // 疑问 concat使用场景是什么？
    // 假设是网络请求依赖，concatSignal subscribeNext:^(id x) block中数据如何处理
    // x是什么数据 还是直接写入缓存 在complete中做处理？？？
    [[self.signalA concat:self.signalB] subscribeNext:^(id x) {
        NSLog(@"concat %@", x);
    }];
    
    NSError *error = [[NSError alloc] initWithDomain:@"shenh" code:12345 userInfo:@{@"23":@"rhjk"}];
    
    //[self.signalA sendError:error];
    //
    [self.signalA sendNext:@"A"];
    [self.signalA sendNext:@"A-1"];
    /** 这里没有调用 sendCompleted 后面的signalB 发送不会接收到*/
    //[self.signalA sendCompleted];
    [self.signalB sendNext:@"1"];
    [self.signalB sendCompleted];
    [self.signalC sendNext:@"2"];
    //[self.signalC sendCompleted];
    

}

- (void)test2 {
    // 创建信号A
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        [subscriber sendNext:@"上部分数据"];
        [subscriber sendCompleted]; // 必须要调用sendCompleted方法！
        return nil;
    }];
    
    // 创建信号B，
    RACSignal *signalsB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        [subscriber sendNext:@"下部分数据"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    
    // concat:按顺序去链接
    //**-注意-**：concat，第一个信号必须要调用sendCompleted
    // 创建组合信号
    RACSignal *concatSignal = [signalA concat:signalsB];
    // 订阅组合信号
    [concatSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    } completed:^{
        NSLog(@"完成");
    }];
}

@end
