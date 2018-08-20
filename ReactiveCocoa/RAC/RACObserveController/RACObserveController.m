/*******************************************************************************
 # File        : RACObserveController.m
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

#import "RACObserveController.h"

@interface RACObserveController ()
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UILabel *label;
@end

@implementation RACObserveController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 配置UI
    [self configUI];
    
    // 配置数据
    [self configData];
}

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}


#pragma mark - 初始化UI
- (void)configUI {
    _textField = [[UITextField alloc] init];
    _textField.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_textField];
    
    _label = [[UILabel alloc] init];
    [self.view addSubview:_label];
    _label.textColor = [UIColor redColor];
    _label.text = @"呵呵呵";  // 为什么呵呵呵没显示
    // 这样试试
    // RAC(self.label, text) = [self.textField.rac_textSignal skip:1];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(180);
        make.width.mas_equalTo(kViewSize6(200));
        make.height.mas_equalTo(kViewSize6(50));
    }];
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.textField);
        make.top.equalTo(self.textField.mas_bottom).offset(kViewSize6(20));
    }];
}

#pragma mark - 初始化数据
- (void)configData {
   
    self.view.backgroundColor = [UIColor whiteColor];
    RAC(self.label, text) = self.textField.rac_textSignal;
    
    
    /** RACObserve Block内部要使用weakself 否则可能会出现循环引用 */
    @weakify(self)
    [RACObserve(self.label, text) subscribeNext:^(id x) {
        @strongify(self)
        NSLog(@"label 值改变了  %@", self.label.text);
    }];
    
}

@end
