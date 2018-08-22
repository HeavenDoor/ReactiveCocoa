/*******************************************************************************
 # File        : FlattenMapController.m
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

#import "FlattenMapController.h"

@interface FlattenMapController ()

@end

@implementation FlattenMapController

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
    [self flatternMapTest];
}

/**
 FlatternMap中的Block返回信号。
 Map中的Block返回对象。
 */
- (void)flatternMapTest {
    RACSubject *subject = [RACSubject subject];
    RACSubject *subjectOfSubject = [RACSubject subject];
    
    [[subjectOfSubject flattenMap:^RACStream *(id value) {
        return value;
    }] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [subjectOfSubject sendNext:subject];
    [subject sendNext:@"zhangdanfeng"];
}

@end
