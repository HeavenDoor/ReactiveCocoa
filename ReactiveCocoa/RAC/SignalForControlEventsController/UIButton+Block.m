//
//  UIButton+Block.m
//  ReactiveCocoa
//
//  Created by shenghai on 2018/8/10.
//  Copyright © 2018年 shenghai. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>

void * kUIButtonBlockKey = &kUIButtonBlockKey;

@implementation UIButton (Block)

- (void)setClickBlock:(void (^)(void))clickBlock {
    objc_setAssociatedObject(self, &kUIButtonBlockKey, clickBlock, OBJC_ASSOCIATION_COPY);
    [self addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void (^)(void))clickBlock {
    return objc_getAssociatedObject(self, &kUIButtonBlockKey);
}

- (void)clicked {
    if (self.clickBlock) {
        self.clickBlock();
    }
}
@end
