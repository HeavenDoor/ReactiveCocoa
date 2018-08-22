/*******************************************************************************
 # File        : ThenController.m
 # Project     : ReactiveCocoa
 # Author      : shenghai
 # Created     : 2018/8/21
 # Corporation : 成都
 # Description :
 Description Logs
 -------------------------------------------------------------------------------
 # Date        : Change Date
 # Author      : Change Author
 # Notes       :
 Change Logs
 ******************************************************************************/

#import "ThenController.h"

@interface ThenController ()

@end

@implementation ThenController

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
    //[self thenSignal];
    [self thenError];
}

// then --- 使用需求：有两部分数据：想让上部分先进行网络请求但是过滤掉数据，然后进行下部分的，拿到下部分数据
// 用于连接两个信号，当第一个信号完成，才会连接then返回的信号
// 注意: 使用then之前的信号的值会被忽略掉
// 遇到错误的时候就不会调用then了
// 使用场景暂时没找到
- (void)thenSignal {
    // 创建信号A
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        NSLog(@"----发送上部分请求---afn");
        [subscriber sendNext:@"上部分数据"];
        [subscriber sendCompleted]; // 必须要调用sendCompleted方法！
        return nil;
    }];
    
    // 创建信号B，
    RACSignal *signalsB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        NSLog(@"--发送下部分请求--afn");
        [subscriber sendNext:@"下部分数据"];
        return nil;
    }];
    // 创建组合信号
    // then;忽略掉第一个信号的所有值
    RACSignal *thenSignal = [signalA then:^RACSignal *{
        // 返回的信号就是要组合的信号
        return signalsB;
    }];
    
    // 订阅信号
    [thenSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
}


- (void)thenError {
    // 创建信号A
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        NSLog(@"----发送上部分请求---afn");
        NSError *error = [[NSError alloc] initWithDomain:@"shenh" code:12345 userInfo:@{@"23":@"rhjk"}];
        
        [subscriber sendError:error];
        //[subscriber sendNext:@"上部分数据"];
        //[subscriber sendCompleted]; // 必须要调用sendCompleted方法！
        return nil;
    }];
    
    // 创建信号B，
    RACSignal *signalsB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        NSLog(@"--发送下部分请求--afn");
        [subscriber sendNext:@"下部分数据"];
        return nil;
    }];
    // 创建组合信号
    // then;忽略掉第一个信号的所有值
    [[[signalA catchTo:[RACSignal return:RACUnit.defaultUnit]] then:^RACSignal *{
        return signalsB;
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

@end
