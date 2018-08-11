/*******************************************************************************
 # File        : HFTControllerManager.h
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

#import "ZXControllerManager.h"
#import <RTRootNavigationController/RTRootNavigationController.h>

@implementation ZXControllerManager

/**
 获取当前可用的导航栏控制器
 
 @return 导航栏控制器
 */
+ (nullable UINavigationController *)getCurrentAvailableNavController {
    UIViewController *currentVC = [self getCurrentVC];
    if (currentVC) {
        return currentVC.rt_navigationController;
    }
    return nil;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [self getCurrentVCFrom:[rootVC presentedViewController]];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    }  else if([rootVC  isKindOfClass:[RTContainerController class]]){
        // 根视图为非导航类
        currentVC = [self getCurrentVCFrom:[(RTContainerController *)rootVC contentViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    if ([currentVC isMemberOfClass:[RTContainerController class]]) {
        return [(RTContainerController *)currentVC contentViewController];
    }
    return currentVC;
}

/**
 从导航栏控制器中获取一个类的实例
 
 @param className 类名
 @return 该类的实例
 */
+ (nullable UIViewController *)getViewControllerFromStack:(UINavigationController *)nav WithClassName:(Class)className {
    NSArray *vcs = nav.rt_navigationController.rt_viewControllers;
    UIViewController *tempVC = nil;
    for (id vc in vcs) {
        if ([vc isMemberOfClass:className]) {
            tempVC = vc;
            break;
        }
    }
    return tempVC;
}

/**
 从导航栏控制器中获取一个类的实例
 
 @param className 类名
 @return 该类的实例
 */
+ (nullable UIViewController *)getViewControllerFromCurrentStackWithClassName:(Class)className {
    return [self getViewControllerFromStack:[self getCurrentAvailableNavController] WithClassName:className];
}

/**
 导航栏控制器中是否存在类
 
 @param className 类型
 @return YES 存在
 */
+ (BOOL)currentStackisContainClass:(Class)className {
    return [self oneStackisContainClass:className WithStack:[self getCurrentAvailableNavController]];
}

/**
 导航栏控制器中是否存在类
 
 @param className 类型
 @return YES 存在
 */
+ (BOOL)oneStackisContainClass:(Class)className WithStack:(UINavigationController *)nav {
    BOOL flag = NO;
    NSArray *vcs = nav.rt_navigationController.rt_viewControllers;
    for (id vc in vcs) {
        if ([vc isMemberOfClass:className]) {
            flag = YES;
            break;
        }
    }
    return flag;
}

/**
 pop 到指定类名的vc
 
 @param className 类名
 */
+ (void)popToVCFromCurrentStackTargetVCClass:(Class)className {
    UIViewController *vc = [self getViewControllerFromCurrentStackWithClassName:className];
    if (vc) {
        [vc.rt_navigationController popToViewController:vc animated:YES complete:nil];
    }
}

/**
 导航栏控制器中移除类
 
 @param className 类名
 @return YES 成功
 */
+ (BOOL)cleanFromCurrentStackTargetVCClass:(Class)className {
    UIViewController *tempVC = [self getViewControllerFromCurrentStackWithClassName:className];
    if (tempVC) {
        [tempVC.rt_navigationController removeViewController:tempVC animated:NO];
        return YES;
    }
    return NO;
}

/**
 导航栏控制器中移除类的数组
 
 @param classArray 类名数组
 */
+ (void)cleanFromCurrentStackTargetVCArrayClass:(NSArray<Class> *)classArray {
    NSMutableArray *tempVCS = [NSMutableArray new];
    UIViewController *currentVC = [self getCurrentVC];
    NSMutableArray *vcs = currentVC.rt_navigationController.viewControllers.mutableCopy;
    for (Class className in classArray) {
        for (RTContainerController *containVC in vcs) {
            if ([containVC.contentViewController isMemberOfClass:className]) {
                if (![tempVCS containsObject:containVC]) {
                    [tempVCS addObject:containVC];
                }
            }
        }
    }
    [vcs removeObjectsInArray:tempVCS];
    [currentVC.rt_navigationController setViewControllers:vcs.copy];
}

/**
 移除当前控制器中，指定的类
 
 @param vcToRemove 要移除的类
 */
+ (void)removeVCFromCurrentStack:(__kindof UIViewController *)vcToRemove {
    [vcToRemove.rt_navigationController removeViewController:vcToRemove];
}

/**
 移除当前控制器中，指定的类
 
 @param vcsToRemove 要移除的类
 */
+ (void)removeVCsFromCurrentStack:(NSArray <__kindof UIViewController *>*)vcsToRemove {
    UIViewController *vc = [vcsToRemove lastObject];
    NSMutableArray *vcs = vc.rt_navigationController.viewControllers.mutableCopy;
    NSMutableArray *tempVcsToRemove = [NSMutableArray new];
    for (id vcToRemove in vcsToRemove) {
        for (RTContainerController *tempVC in vcs) {
            if ([vcToRemove isEqual:tempVC] || [vcToRemove isEqual:tempVC.contentViewController]) {
                [tempVcsToRemove addObject:tempVC];
                break;
            }
        }
    }
    [vcs removeObjectsInArray:tempVcsToRemove];
    [vc.rt_navigationController setViewControllers:vcs];
}

/**
 在当前控制器栈中添加一个vc到index位置
 
 @param vc vc
 @param index 要添加到位置
 */
+ (void)addVCToCurrentStack:( __kindof UIViewController * _Nonnull)vc toIndex:(NSUInteger)index {
    [self addVCsToCurrentStack:@[vc] toIndex:index];
}

/**
 在当前控制器栈中添加一个vc到index位置
 
 @param vcs vcs
 @param index 要添加到位置
 */
+ (void)addVCsToCurrentStack:(NSArray <__kindof UIViewController * > *_Nonnull)vcs toIndex:(NSUInteger)index {
    for (UIViewController *vc in vcs) {
        vc.navigationItem.leftBarButtonItem = [self leftBarButtonItemWithTarget:self action:@selector(backAction)];
        [self setVC:vc disableInteractivePop:NO];
    }
    
    UIViewController *currentVC = [self getCurrentVC];
    NSMutableArray *array = currentVC.rt_navigationController.viewControllers.mutableCopy;
    if (index >= array.count) {
        [array addObjectsFromArray:vcs];
    } else {
        [array insertObjects:vcs atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, vcs.count)]];
    }
    [currentVC.rt_navigationController setViewControllers:array];
}

+ (void)backAction {
    [[self getCurrentAvailableNavController] popViewControllerAnimated:YES];
}

/**
 全局的统一的返回按钮
 */
+ (UIBarButtonItem *)leftBarButtonItemWithTarget:(nullable id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 44, 44);
    // 让按钮内部的所有内容左对齐
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // 让按钮的内容往右边偏移3
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 修改导航栏左边的item
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

/**
 导航栏控制器中移动类到最底
 
 @param nav 导航栏控制器
 */
+ (void)moveToStackBottom:(UINavigationController *)nav {
    [nav.rt_navigationController popToRootViewControllerAnimated:NO];
}

/**
 导航栏控制器中移动类到最底
 
 @param nav 导航栏控制器
 */
+ (void)moveToStackBottom:(UINavigationController *)nav animated:(BOOL)animated {
    [nav.rt_navigationController popToRootViewControllerAnimated:animated];
}
/**
 保持栈中仅有一个该类
 
 @param vc 类的实例
 @param nav 导航栏控制器
 */
+ (void)keepOnlyVC:(UIViewController *)vc FormStackWithNavigationController:(UINavigationController *)nav {
    NSMutableArray *tempVCS = [NSMutableArray new];
    NSMutableArray<RTContainerController *> *vcs = nav.rt_navigationController.viewControllers.mutableCopy;
    for (RTContainerController *tempVC in vcs) {
        // 得到当前控制器中所有的vc
        if ([tempVC.contentViewController isMemberOfClass:[vc class]]) {
            [tempVCS addObject:tempVC];
        }
    }
    // 保留最后一个
    [tempVCS removeLastObject];
    [vcs removeObjectsInArray:tempVCS];
    [nav.rt_navigationController setViewControllers:vcs];
}

/**
 保持栈中仅有一个该类
 
 @param vc 类的实例
 */
+ (void)keepOnlyVC:(UIViewController *)vc {
    [self keepOnlyVC:vc FormStackWithNavigationController:[self getCurrentAvailableNavController]];
}

/**
 让vc禁用右滑返回手势
 
 @param vc vc
 @param disable YES:禁用返回手势，NO:可用  默认为NO
 */
+ (void)setVC:(UIViewController *)vc disableInteractivePop:(BOOL)disable {
    vc.rt_disableInteractivePop = disable;
}

/**
 判断当前viewcontroller是push还是present的方式显示的

 @param vc vc
 @return YES Push NO present
 */
+ (BOOL)getShowWayForVC:(UIViewController *)vc {
    if (!vc) {
        vc = [self getCurrentVC];
    }
    NSArray *viewcontrollers = vc.navigationController.viewControllers;
    if (viewcontrollers.count > 1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count - 1] == vc) {
            // push方式
            return YES;
        }
    }
    return NO;
}

@end
