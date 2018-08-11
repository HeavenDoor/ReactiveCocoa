/*******************************************************************************
 # File        : RACWeakifyController.m
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

#import "RACWeakifyController.h"


#pragma mark - 这是一个入参为nil就会崩溃的函数
void crashSelfnil(id obj) {
    assert(obj);
}
@interface RACWeakifyController ()

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UILabel *label;

@end

@implementation RACWeakifyController

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
    self.button = [[UIButton alloc] init];
    self.button.backgroundColor = [UIColor darkGrayColor];
    [self.button setTitle:@"点我" forState:UIControlStateNormal];
    [self.view addSubview:self.button];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-kViewSize6(30));
        make.width.mas_equalTo(kViewSize6(200));
        make.height.mas_equalTo(kViewSize6(120));
    }];
    
    
    
    @weakify(self)
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"rac_signalForControlEvents 回调事件触发");
        @strongify(self)
        self.label.text = @"循环引用 退出不会调dealloc";
    }];
    
    
    /**
     使用倒计时和crashSelfnil只是为了模拟一种场景，
     有些传入参数为nil的函数会导致崩溃
     比如网络请求使用了dispatch_group
     dispatch_group_leave(self.group)传空值会崩溃
     */
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"rac_signalForControlEvents 回调事件触发");
        self_weak_.label.text = @"循环引用 退出不会调dealloc";
        [[RACScheduler mainThreadScheduler] afterDelay:15 schedule:^{
            //crashSelfnil(self_weak_);
        }];
    }];
    
    /** 解决方案
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"rac_signalForControlEvents 回调事件触发");
        self_weak_.label.text = @"循环引用 退出不会调dealloc";
        [[RACScheduler mainThreadScheduler] afterDelay:15 schedule:^{
            crashSelfnil(self_weak_);
        }];
    }]; */
    
    
    /** 在block里面使用的__strong修饰的weakSelf是为了在函数生命周期中防止self提前释放。
     strongSelf是一个自动变量当block执行完毕就会释放自动变量strongSelf不会对self进行一直进行强引用
     */
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"rac_signalForControlEvents 回调事件触发");
        self_weak_.label.text = @"循环引用 退出不会调dealloc";
        @strongify(self)
        [[RACScheduler mainThreadScheduler] afterDelay:15 schedule:^{
            crashSelfnil(self);
        }];
    }];
    
    
    
    self.label = [[UILabel alloc] init];
    self.label.textColor = [UIColor darkGrayColor];
    self.label.font = kFontSize6(13);
    [self.view addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.button.mas_bottom).offset(kViewSize6(15));
    }];
    self.label.text = @"呵呵呵呵";
}



#pragma mark - 初始化数据
- (void)configData {
    
}

@end
