/*******************************************************************************
 # File        : ZXNavigationController.m
 # Project     : ZXBasePro
 # Author      : shenghai
 # Created     : 2018/03/29
 # Corporation : 四川蛙众科技有限公司
 # Description :
 Description Logs
 -------------------------------------------------------------------------------
 # Date        : 2018/03/29
 # Author      : shenghai
 # Notes       :
 Change Logs
 ******************************************************************************/

#import "ZXNavigationController.h"
#import "ZXCommonDefinition.h"
#import "ZXControllerManager.h"

@interface ZXNavigationController ()

@end

@implementation ZXNavigationController

// 第一次加载才会初始化
+ (void)initialize {
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.translucent = NO;
    // 背景颜色
    [bar setBarTintColor:RGBGRAY(249.0f)];
    // item文字颜色
    [bar setTintColor:RGBGRAY(51.0f)];
    // 中间标题颜色
//    [UIFont fontWithName:@"PingFang-SC-Medium" size:17.0f]
    [bar setTitleTextAttributes:@{NSFontAttributeName:kFontSize6(17.0f), NSForegroundColorAttributeName:RGBGRAY(51.0f)}];
    [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[UIImage new]];
}

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
}

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {

}

#pragma mark - 初始化界面
- (void)createUI {

}

#pragma mark ----------------------------- 私有方法 ------------------------------
/**
 * 可以在这个方法中拦截所有push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!viewController) {
        NSArray *syms = [NSThread  callStackSymbols];
        NSString *message = @"跳转的界面未找到，可能是初始化失败。";
        if (syms.count >= 3) {
            NSString *mT = syms[2];
            
            NSRange startRange = [mT rangeOfString:@"-"];
            NSRange endRange = [mT rangeOfString:@"+"];
            NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
            NSString *result = [mT substringWithRange:range];
            message = [NSString stringWithFormat:@"%@\n界面初始化失败", result];
        }
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"请检查" message:message delegate:nil cancelButtonTitle:@"明白" otherButtonTitles:nil, nil];
        [aler show];
        return ;
    }
    
    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
        viewController.navigationItem.leftBarButtonItem = [ZXControllerManager leftBarButtonItemWithTarget:self action:@selector(backAction)];
        // 默认设置返回手势可用
        [ZXControllerManager setVC:viewController disableInteractivePop:NO];
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    // viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
    // 修复标签栏控制器上移的问题
    if (@available(iOS 11.0, *)){
        // 修改tabBra的frame
        CGRect frame = self.tabBarController.tabBar.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
        self.tabBarController.tabBar.frame = frame;
    }
}

- (void)backAction {
    [self popViewControllerAnimated:YES];
}

#pragma mark ----------------------------- 公用方法 ------------------------------

#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------


@end
