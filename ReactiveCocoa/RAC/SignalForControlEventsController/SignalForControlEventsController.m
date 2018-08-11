/*******************************************************************************
 # File        : SignalForControlEventsController.m
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

#import "SignalForControlEventsController.h"
#import "UIButton+Block.h"

@interface SignalForControlEventsController ()

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UILabel *label;

@end

@implementation SignalForControlEventsController

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
    
    
    self.button.clickBlock = ^{
        NSLog(@"clickedBloack 事件回调");
        self_weak_.label.text = @"使用Block不注意循环引用会出大问题";
    };
    
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

/*
 使用block替换target-action原理
 创建一个控件的category 如UIButton+Block
 在category中添加block属性 由于category不支持添加属性，
 所以使用到运行时方法objc_setAssociatedObject 和 objc_getAssociatedObject
 在category中设置blcok的时候调用target-action，action中调用block对象
 这样就实现了控件创建和回调的代码在同一个代码块中，会提高查找（开发）效率，但是要注意blcok使用中不小心出现的循环引用问题
 */

@end
