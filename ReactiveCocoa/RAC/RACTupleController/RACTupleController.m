/*******************************************************************************
 # File        : RACTupleController.m
 # Project     : ReactiveCocoa
 # Author      : shenghai
 # Created     : 2018/8/11
 # Corporation : 成都
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "RACTupleController.h"

@interface RACTupleController ()

@end

@implementation RACTupleController

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
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSDictionary *dict = @{@"name":@"shenghai", @"age": @"22"};
        RACTuple *tupe = RACTuplePack(@"tyuiuyu", dict);
        [subscriber sendNext:tupe];
        [subscriber sendCompleted];
        return nil;
    }];
    
    [signal subscribeNext:^(RACTuple *tupe) {
        RACTupleUnpack(NSString *key, NSDictionary *value) = tupe;
        NSLog(@"key : %@, value : %@", key, value);
    } ];

}

#pragma mark - 初始化数据
- (void)configData {
    
}

@end
