//
//  BaseView.m
//  PageBaseTest
//
//  Created by roy on 16/1/27.
//  Copyright © 2016年 roy. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

//覆盖方法  实现点击空白隐藏键盘 缺点：点击所有地方都会隐藏键盘  包括编辑框
- (UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView * result = [super hitTest:point withEvent:event];
    [self endEditing:YES];
    return result;
}

@end