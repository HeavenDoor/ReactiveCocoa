/*******************************************************************************
 # File        : NSUserDefaultsController.m
 # Project     : ReactiveCocoa
 # Author      : shenghai
 # Created     : 2018/8/10
 # Corporation : 成都柠檬云网络技术有限公司
 # Description :
 Description Logs
 -------------------------------------------------------------------------------
 # Date        : Change Date
 # Author      : Change Author
 # Notes       :
 Change Logs
 ******************************************************************************/

NSString * const kNSUserDefaultsControllerID = @"com.ReactiveCocoa.NSUserDefaultsControllerID";

#import "NSUserDefaultsController.h"

@interface NSUserDefaultsController ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation NSUserDefaultsController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 配置数据
    [self configData];
    // 配置UI
    [self configUI];
    
    
    //[self observerNSUserDefaults];
    [self observerNSUserDefaults1];
    //[self observerNSUserDefaults2];
}

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化UI
- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.button = [[UIButton alloc] init];
    self.button.backgroundColor = [UIColor darkGrayColor];
    [self.button setTitle:@"NSUserDefaults" forState:UIControlStateNormal];
    [self.view addSubview:self.button];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-kViewSize6(30));
        make.width.mas_equalTo(kViewSize6(200));
        make.height.mas_equalTo(kViewSize6(120));
    }];
    
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"修改了 NSUserDefaults 的 kNSUserDefaultsControllerID 值");
        NSInteger num = 100 +  (arc4random() % 101);
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"shenghai %ld", num] forKey:kNSUserDefaultsControllerID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}

#pragma mark - 初始化数据
- (void)configData {
    
}

- (void)observerNSUserDefaults {
    /** 这样写会有两个问题
     问题1：observerNSUserDefaults调用的时候回默认执行 输出 NSUserDefaults kNSUserDefaultsControllerID KEY 值改变为 。。。
     问题2：当前控制器pop释放掉 NSUserDefaults kNSUserDefaultsControllerID 的值改变 依然会打印
     */
    [[[NSUserDefaults standardUserDefaults] rac_channelTerminalForKey:kNSUserDefaultsControllerID] subscribeNext:^(id x) {
        NSLog(@"NSUserDefaults kNSUserDefaultsControllerID KEY 值改变为 %@", x);
    }];
}

/** 问题1解决方案 */
- (void)observerNSUserDefaults1 {
    /** skip:1 会 跳过/忽略/不处理 第一次发送的数据
     NSUserDefaults RAC订阅后就会默认发送一次 要忽略掉这次改变
     */
    [[[[NSUserDefaults standardUserDefaults] rac_channelTerminalForKey:kNSUserDefaultsControllerID] skip:1] subscribeNext:^(id x) {
        NSLog(@"NSUserDefaults kNSUserDefaultsControllerID KEY 值改变为 %@", x);
    }];
}

/** 问题1 问题2终极解决方案 */
- (void)observerNSUserDefaults2 {
    /** takeUntil:self.rac_willDeallocSignal 当前控制器释放的时候不再订阅数据  */
    [[[[[NSUserDefaults standardUserDefaults] rac_channelTerminalForKey:kNSUserDefaultsControllerID] skip:1] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        NSLog(@"NSUserDefaults kNSUserDefaultsControllerID KEY 值改变为 %@", x);
    }];
}

@end
