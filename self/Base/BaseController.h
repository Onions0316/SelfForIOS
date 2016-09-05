//
//  BaseController.h
//  singeViewTest
//
//  Created by roy on 16/1/6.
//  Copyright © 2016年 roy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiManager.h"
#import "UIUtil.h"


#ifndef BaseController_h
#define BaseController_h

/*
 *  创建类型宏
 */
#define CREATE_TYPE_PROPERTY_TO_VIEW(__TYPE__,__NAME__)\
@property (nonatomic,strong) __TYPE__ * __NAME__;

@interface BaseController : UIViewController

{
    NSString * logName;
}
@property (nonatomic,assign) CGFloat topSize;
@property (nonatomic,strong) NSString * logName;
@property (nonatomic,assign) BOOL showBack;
@property (nonatomic,assign) BOOL showLogout;
@property (nonatomic,assign) BOOL checkLogin;
@property (nonatomic,strong) NSString * navTitle;
/**需要屏幕切换*/
@property (nonatomic,assign) BOOL needChangeView;

- (void) goControllerByClass:(Class) goClass;

- (void) goController:(UIViewController *) controller;

- (void) updateTitle:(NSString *) navTitle;

- (void) logStr:(NSString*) logStr;

- (void) setDetailAmount:(UILabel *) label amount:(float) amount;

- (void) clickBack;
- (void) drawContent;
- (void) addTitleButton:(NSString*) imageName sel:(SEL) sel;

- (void) showAlert:(NSString *)title
           message:(NSString *)message
               sel:(SEL) sel;

- (void) showAlert:(NSString *)title
           message:(NSString *)message
               sel:(SEL) sel
          leftText:(NSString *)leftText
         rightText:(NSString *)rightText;
@end

#endif /* BaseController_h */
