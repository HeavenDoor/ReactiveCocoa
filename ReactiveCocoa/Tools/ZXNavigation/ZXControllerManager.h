/*******************************************************************************
 # File        : ZXControllerManager.h
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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXControllerManager : NSObject

/**
 获取当前可用的导航栏控制器
 
 @return 导航栏控制器
 */
+ (nullable UINavigationController *)getCurrentAvailableNavController;

/**
 获取当前屏幕的viewcontroller

 @return 当前屏幕显示的最顶层的vc
 */
+ (UIViewController *)getCurrentVC;

/**
 从导航栏控制器中获取一个类的实例
 
 @param className 类名
 @return 该类的实例
 */
+ (nullable UIViewController *)getViewControllerFromCurrentStackWithClassName:(Class)className;

/**
 从导航栏控制器中获取一个类的实例
 
 @param className 类名
 @return 该类的实例
 */
+ (nullable UIViewController *)getViewControllerFromStack:(UINavigationController *)nav WithClassName:(Class)className;

/**
 导航栏控制器中是否存在类
 
 @param className 类型
 @return YES 存在
 */
+ (BOOL)currentStackisContainClass:(Class)className;

/**
 导航栏控制器中是否存在类
 
 @param className 类型
 @return YES 存在
 */
+ (BOOL)oneStackisContainClass:(Class)className WithStack:(UINavigationController *)nav;

/**
 导航栏控制器中移动类到最底
 
 @param nav 导航栏控制器
 */
+ (void)moveToStackBottom:(UINavigationController *)nav;
/**
 导航栏控制器中移动类到最底
 
 @param nav 导航栏控制器
 */
+ (void)moveToStackBottom:(UINavigationController *)nav animated:(BOOL)animated;

/**
 pop 到指定类名的vc

 @param className 类名
 */
+ (void)popToVCFromCurrentStackTargetVCClass:(Class)className;

/**
 导航栏控制器中移除类
 
 @param className 类名
 @return YES 成功
 */
+ (BOOL)cleanFromCurrentStackTargetVCClass:(Class)className;

/**
 导航栏控制器中移除类的数组
 
 @param classArray 类名数组
 */
+ (void)cleanFromCurrentStackTargetVCArrayClass:(NSArray<Class> *)classArray;

/**
 移除当前控制器中，指定的类

 @param vcToRemove 要移除的类
 */
+ (void)removeVCFromCurrentStack:(__kindof UIViewController *)vcToRemove;

/**
 移除当前控制器中，指定的类,数组
 
 @param vcsToRemove 要移除的类的数组
 */
+ (void)removeVCsFromCurrentStack:(NSArray <__kindof UIViewController *>*)vcsToRemove;


/**
 在当前控制器栈中添加一个vc到index位置

 @param vc vc
 @param index 要添加到位置
 */
+ (void)addVCToCurrentStack:( __kindof UIViewController * _Nonnull)vc toIndex:(NSUInteger)index;

/**
 在当前控制器栈中添加一个vc到index位置
 
 @param vcs vcs
 @param index 要添加到位置
 */
+ (void)addVCsToCurrentStack:(NSArray <__kindof UIViewController * > * _Nonnull)vcs toIndex:(NSUInteger)index;

/**
 保持栈中仅有一个该类
 
 @param vc 类的实例
 @param nav 导航栏控制器
 */
+ (void)keepOnlyVC:(UIViewController *)vc FormStackWithNavigationController:(UINavigationController *)nav;

/**
 保持栈中仅有一个该类
 
 @param vc 类的实例
 */
+ (void)keepOnlyVC:(UIViewController *)vc;

/**
 让vc禁用右滑返回手势

 @param vc vc
 @param disable YES:禁用返回手势，NO:可用  默认为NO
 */
+ (void)setVC:(UIViewController *)vc disableInteractivePop:(BOOL)disable;

/**
 全局的统一的返回按钮
 */
+ (UIBarButtonItem *)leftBarButtonItemWithTarget:(nullable id)target action:(SEL)action;

/**
 判断当前viewcontroller是push还是present的方式显示的
 
 @param vc vc
 @return YES Push NO present
 */
+ (BOOL)getShowWayForVC:(nullable UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
