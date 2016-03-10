//
//  BaseController.h
//  singeViewTest
//
//  Created by roy on 16/1/6.
//  Copyright © 2016年 roy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
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
@property (nonatomic,assign) BOOL isOld;

- (void) goControllerByClass:(Class) goClass;

- (void) goController:(UIViewController *) controller;

- (void) updateTitle:(NSString *) navTitle;

- (void) logStr:(NSString*) logStr;

- (void) setDetailAmount:(UILabel *) label amount:(NSNumber *) amount;

- (void) showAlert:(NSString *) title
           message:(NSString *) message
        controller:(UIViewController *) controller;

- (void) showAlert:(NSString *)title
           message:(NSString *)message
        controller:(UIViewController *)controller
               sel:(SEL) sel;

- (void) showConfirm:(NSString *) title
             message:(NSString *) message
          controller:(UIViewController *) controller
               okSel:(SEL) okSel
           cancelSel:(SEL) cancelSel;

- (void) showMessage:(NSString *)title
             message:(NSString *)message
          controller:(UIViewController *)controller
             actions:(NSMutableDictionary *) actions;
- (void) showBase:(UIAlertController *) alert
          actions:(UIViewController *) controller;
- (void) clickBack;
- (void) drawContent;
- (void) addTitleButton:(NSString*) imageName sel:(SEL) sel;
@end

#endif /* BaseController_h */
