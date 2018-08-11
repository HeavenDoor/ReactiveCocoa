//
//  UIButton+Block.h
//  ReactiveCocoa
//
//  Created by shenghai on 2018/8/10.
//  Copyright © 2018年 shenghai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Block)


@property (nonatomic, copy) void (^clickBlock)(void);

@end
