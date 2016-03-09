//
//  BaseController.m
//  singeViewTest
//
//  Created by roy on 16/1/6.
//  Copyright © 2016年 roy. All rights reserved.
//

#import "BaseController.h"
#import "BaseObjects.m"
#import "AccountInfoManager.h"

#define TitleTag 9001

@interface BaseController()

@property (nonatomic,assign) BOOL showState;
@property (nonatomic,strong) UIView * navView;
@property (nonatomic,assign) int titleButtonCount;
@property (nonatomic,assign) int titleTop;

@end

@implementation BaseController

@synthesize logName;


nullBlocks myblocks;

- (id) init{
    if(self=[super init]){
        self.logName = @"Base";
        myblocks = ^(UIAlertAction * _Nonnull action){};
        self.showBack = YES;
        self.checkLogin = YES;
        self.showLogout = [[AccountInfoManager sharedInstance] hasLogin];
        self.showState = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0");
        self.titleButtonCount = 0;
    }
    return self;
}

-(void) viewDidLoad{
    [super viewDidLoad];
    
    self.view = [[BaseView alloc] initWithFrame:self.view.frame];
    
    //白色背景
    self.view.backgroundColor = [UIColor whiteColor];// [[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:1];
    
    if (self.showState){
        self.topSize = 20;
    }else{
        self.topSize = 0;
    }
    self.titleTop = self.topSize;
    
    [self drawTitle];
    
    [self drawContent];
    [self.view addSubview:self.navView];
    
    if(self.checkLogin){
        [[AccountInfoManager sharedInstance] checkLogin:self];
    }
}
- (void) drawContent{}
//画页面title
- (void) drawTitle{
    if(self.navTitle){
        UIColor * titleBG = Default_Color;
        CGRect titleRect = CGRectMake(0, 0, Main_Screen_Width, Main_Title_Height+self.topSize);
        self.navView = [[UIView alloc] initWithFrame:titleRect];
        if(self.showState){
            UIView * state = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, self.topSize)];
            state.backgroundColor = titleBG;
            [self.navView addSubview:state];
        }
        self.navView.backgroundColor = titleBG;
        if(self.showBack){
            CGFloat backWidth = Main_Title_Button_Width;
            CGRect backRect = CGRectMake(0, self.titleTop, backWidth, Main_Title_Height);
            [UIUtil addButtonInView:self.navView image:[UIImage imageNamed:@"back"] rect:backRect sel:@selector(clickBack) controller:self tag:nil];
            /*
            UIButton * back = [UIButton buttonWithType:UIButtonTypeCustom];
            back.frame= CGRectMake(0, 0, backWidth, Main_Title_height);
            [back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
            [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
            [self.navView addSubview:back];*/
        }
        if(self.showLogout){
            self.titleButtonCount++;
            CGFloat logoutWidth = Main_Title_Button_Width;
            CGRect backRect = CGRectMake(Main_Screen_Width-logoutWidth-Default_View_Space, self.titleTop, logoutWidth, Main_Title_Height);
            [UIUtil addButtonInView:self.navView image:[UIImage imageNamed:@"logout"] rect:backRect sel:@selector(logout) controller:self tag:nil];
        }
        [self updateTitle:self.navTitle];
        self.topSize+=Main_Title_Height;
    }
}
/*
 *  添加标题按钮
 */
- (void) addTitleButton:(NSString*) imageName sel:(SEL) sel{
    CGFloat width = Main_Title_Button_Width;
    CGFloat x = Main_Screen_Width-width-(self.titleButtonCount*(width+Default_View_Space));
    if(self.titleButtonCount==0){
        x-=Default_View_Space;
    }
    CGRect rect = CGRectMake(x, self.titleTop, width, Main_Title_Height);
    [UIUtil addButtonInView:self.navView image:[UIImage imageNamed:imageName] rect:rect sel:sel controller:self tag:nil];
    self.titleButtonCount++;
}
//更新页面title
- (void) updateTitle:(NSString *) navTitle{
    if(self.navView){
        UILabel * lblTitle = [self.navView viewWithTag:TitleTag];
        CGSize titleTextSize = [UIUtil textSizeAtString:navTitle font:Default_Font];
        if(lblTitle){
            CGRect rect = lblTitle.frame;
            rect.size.width = titleTextSize.width;
            rect.origin.x = (Main_Screen_Width-titleTextSize.width)/2;
            lblTitle.frame = rect;
            lblTitle.text = navTitle;
        }else{
            CGRect rect = CGRectMake((Main_Screen_Width-titleTextSize.width)/2, self.topSize, titleTextSize.width, Main_Title_Height);
            lblTitle = [UIUtil addLableInView:self.navView text:navTitle rect:rect tag:[NSNumber numberWithInt:TitleTag]];
        }
        lblTitle.textColor = [UIColor whiteColor];
        /*
        [[UILabel alloc] initWithFrame:];
        lblTitle.tag = TitleTag;
        lblTitle.text = navTitle;
        lblTitle.textColor = [UIColor whiteColor];
        lblTitle.font = Default_Font;
        [self.navView addSubview:lblTitle];*/
    }
}

- (void) goControllerByClass:(Class) goClass{
    if([goClass isSubclassOfClass:[UIViewController class]]){
        UIViewController * controller;
        for(UIViewController * obj in self.navigationController.viewControllers){
            if([obj isMemberOfClass: goClass]){
                controller = obj;
                break;
            }
        }
        if(controller){
            SEL sel = @selector(refresh);
            if([controller respondsToSelector:sel]){
                [controller performSelector:sel];
            }
            [self.navigationController popToViewController:controller animated:YES];
        }else{
            controller = [[goClass alloc] init];
            [self goController:controller];
        }
    }
}

- (void) goController:(UIViewController *) controller{
    [self.navigationController pushViewController:controller animated:YES];
}
/*
 *  返回
 */
- (void) clickBack{
    int count = self.navigationController.viewControllers.count;
    if(count>1){
        UIViewController * controller = self.navigationController.viewControllers[count-2];
        if(controller){
            SEL sel = @selector(refresh);
            if([controller respondsToSelector:sel]){
                [controller performSelector:sel];
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
//注销
- (void) logout{
    [[AccountInfoManager sharedInstance] logout:self];
}

- (void) logStr:(NSString*) logStr{
    NSLog(@"%@ log :%@",self.logName,logStr);
}

- (void) showAlert:(NSString *)title message:(NSString *)message controller:(UIViewController *)controller{
    [self showAlert:title message:message controller:controller sel:nil];
}

//设置金额
- (void) setDetailAmount:(UILabel *) label amount:(NSNumber *) amount{
    amount = [Util toNumber:amount];
    float amountFloat = amount.floatValue;
    label.text = [Util numberToString:amount];
    if(amountFloat>0){
        label.textColor = [UIColor blueColor];
    }else if(amountFloat <0){
        label.textColor =[UIColor redColor];
    }
}

- (void) showAlert:(NSString *)title
           message:(NSString *)message
        controller:(UIViewController *)controller
               sel:(SEL) sel{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        if(sel && [self respondsToSelector:sel]){
            [self performSelector:sel];
        }
    }];
    [alert addAction:action];
    [self showBase:alert actions:controller];
}

- (void) showConfirm:(NSString *) title
             message:(NSString *) message
          controller:(UIViewController *) controller
               okSel:(SEL) okSel
           cancelSel:(SEL) cancelSel{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        if(okSel && [self respondsToSelector:okSel]){
            [self performSelector:okSel];
        }
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        if(cancelSel && [self respondsToSelector:cancelSel]){
            [self performSelector:cancelSel];
        }
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self showBase:alert actions:controller];
}

- (void) showMessage:(NSString *)title
             message:(NSString *)message
          controller:(UIViewController *)controller
             actions:(NSMutableDictionary *) actions{
    UIAlertController * alert =[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:myblocks]];
    if(actions!=nil){
        for(id key in actions.allKeys){
            id value = [actions objectForKey:key];
            UIAlertAction * action = [UIAlertAction actionWithTitle:key style:UIAlertActionStyleDestructive handler:(nullBlocks)value];
            [alert addAction:action];
        }
    }
    [self showBase:alert actions:controller];
}

- (void) showBase:(UIAlertController *) alert
          actions:(UIViewController *) controller{
    if(controller==nil){
        controller = self;
    }
    [controller presentViewController:alert animated:true completion:nil];
}

@end
