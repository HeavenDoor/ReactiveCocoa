/*******************************************************************************
 # File        : ZipController.m
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

#import "ZipController.h"

@interface ZipController ()
@property (nonatomic, strong) RACSubject *signalA;

@property (nonatomic, strong) RACSubject *signalB;

@property (nonatomic, strong) RACSubject *signalC;
@end

@implementation ZipController

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
    [self testCollectSignalsAndCombineLatestOrZip];
}

- (void)testCollectSignalsAndCombineLatestOrZip {
    //1
    RACSignal *numbers = @[@(0), @(1), @(2)].rac_sequence.signal;
    
    RACSignal *letters1 = @[@"A", @"B", @"C"].rac_sequence.signal;
    RACSignal *letters2 = @[@"X", @"Y", @"Z"].rac_sequence.signal;
    RACSignal *letters3 = @[@"M", @"N"].rac_sequence.signal;
    NSArray *arrayOfSignal = @[letters1, letters2, letters3]; //2
    
    
    [[[numbers
       map:^id(NSNumber *n) {
           //3
           return arrayOfSignal[n.integerValue];
       }]
      collect]  //4
     subscribeNext:^(NSArray *array) {
         NSLog(@"%@, %@", [array class], array);
     } completed:^{
         NSLog(@"completed");
     }];
}
#pragma mark - 初始化数据
- (void)configData {
    //[self test1];
    //[self test2];
}
 

/** zip:把N个信号压缩成一个信号，只有当N个信号同时发出信号内容时，
 并且把N个信号的内容合并成一个元组，才会触发压缩流的next事件。（并不止两个信号）
 tips:
 如果会触发多次zip，按照发送顺序zip 先发送的先zip
 complete 任意一个信号都发送complete的时候就会被调用
 */
- (void)test1 {
    self.signalA = [RACSubject subject];
    self.signalB = [RACSubject subject];
    self.signalC = [RACSubject subject];
    
    RACSignal *signal = [RACSignal zip:@[self.signalA,self.signalB,self.signalC] reduce:^id(NSNumber *s1,NSNumber *s2,NSString *s3){
        return RACTuplePack(s1,s2,s3);
    }];
    
    [signal subscribeNext:^(RACTuple *tuple) {
        RACTupleUnpack(NSNumber *num1,NSNumber *num2,NSString *s3) = tuple;
        
        NSLog(@"%@%@%@",num1,num2,s3);
    }completed:^{
        NSLog(@"complete");
    }];
    
    [self.signalC sendNext:@"C "];
    [self.signalA sendNext:@"A "];
    [self.signalA sendNext:@"A-side "];
    [self.signalB sendNext:@"B "];

//    [self.signalC sendCompleted];
//    [self.signalA sendCompleted];
//    [self.signalB sendCompleted];
    
    [self.signalB sendNext:@"B-1 "];
    [self.signalA sendNext:@"A-1 "];
    [self.signalC sendNext:@"C-1 "];
    
//    [self.signalC sendCompleted];
//    [self.signalA sendCompleted];
//    [self.signalB sendCompleted];
}

- (void)test2 {
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendNext:@10];
        //[subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@2];
        [subscriber sendNext:@20];
        //[subscriber sendCompleted];
        return nil;
    }];
    RACSignal *signal3 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"3"];
        [subscriber sendNext:@"3-side"];
        //[subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signal = [RACSignal zip:@[signal1,signal2,signal3] reduce:^id(NSNumber *s1,NSNumber *s2,NSString *s3){
        return RACTuplePack(s1,s2,s3);
    }];
    
    [signal subscribeNext:^(RACTuple *tuple) {
        RACTupleUnpack(NSNumber *num1,NSNumber *num2,NSString *s3) = tuple;
        
        NSLog(@"%@%@%@",num1,num2,s3);
    }completed:^{
        NSLog(@"complete");
    }];
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
