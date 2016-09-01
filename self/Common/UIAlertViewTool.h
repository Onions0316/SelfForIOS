//
//  UIAlertViewTool.h
//  SharpEyes
//
//  Created by 彭颖 on 16/8/12.
//  Copyright © 2016年 DLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertViewTool : NSObject

/**通过委托人注册alert*/
- (instancetype)initWithDelegate: (id) delegate;

/**判断系统来控制alert显示方式*/
- (void) showAlert:(NSString *)title
           message:(NSString *)message
               sel:(SEL) sel;
/*
 *判断系统来控制alert显示方式
 */
- (void) showAlert:(NSString *)title
           message:(NSString *)message
               sel:(SEL) sel
          leftText:(NSString *)leftText
         rightText:(NSString *)rightText;
@end