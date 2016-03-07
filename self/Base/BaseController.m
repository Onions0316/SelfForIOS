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
    
    [self drawTitle];
    
    if(self.checkLogin){
        [[AccountInfoManager sharedInstance] checkLogin:self];
    }
}
//画页面title
- (void) drawTitle{
    if(self.navTitle){
        UIColor * titleBG = [UIColor colorWithRed:54.0/255 green:181.0/255 blue:236.0/255 alpha:1];
        if(self.showState){
            UIView * state = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, self.topSize)];
            state.backgroundColor = titleBG;
            [self.view addSubview:state];
        }
        CGRect titleRect = CGRectMake(0, self.topSize, Main_Screen_Width, Main_Title_Height);
        self.navView = [[UIView alloc] initWithFrame:titleRect];
        self.navView.backgroundColor = titleBG;
        if(self.showBack){
            CGFloat backWidth = 40;
            CGRect backRect = CGRectMake(0, 0, backWidth, Main_Title_Height);
            [UIUtil addButtonInView:self.navView image:[UIImage imageNamed:@"back"] rect:backRect sel:@selector(clickBack) controller:self tag:nil];
            /*
            UIButton * back = [UIButton buttonWithType:UIButtonTypeCustom];
            back.frame= CGRectMake(0, 0, backWidth, Main_Title_height);
            [back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
            [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
            [self.navView addSubview:back];*/
        }
        if(self.showLogout){
            CGFloat logoutWidth = Main_Title_Height;
            CGRect backRect = CGRectMake(Main_Screen_Width-logoutWidth-Default_View_Space, 0, logoutWidth, Main_Title_Height);
            [UIUtil addButtonInView:self.navView image:[UIImage imageNamed:@"logout"] rect:backRect sel:@selector(logout) controller:self tag:nil];
        }
        [self updateTitle:self.navTitle];
        [self.view addSubview:self.navView];
        self.topSize+=Main_Title_Height;
    }
}
//更新页面title
- (void) updateTitle:(NSString *) navTitle{
    if(self.navView){
        [[self.navView viewWithTag:TitleTag] removeFromSuperview];
        CGSize titleTextSize = [UIUtil textSizeAtString:navTitle font:Default_Font];
        CGRect rect = CGRectMake((Main_Screen_Width-titleTextSize.width)/2, 0, titleTextSize.width, Main_Title_Height);
        UILabel * lblTitle = [UIUtil addLableInView:self.navView text:navTitle rect:rect tag:[NSNumber numberWithInt:TitleTag]];
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) logout{
    [[AccountInfoManager sharedInstance] logout:self];
}

- (void) logStr:(NSString*) logStr{
    NSLog(@"%@ log :%@",self.logName,logStr);
}

- (void) showAlert:(NSString *)title message:(NSString *)message controller:(UIViewController *)controller{
    [self showAlert:title message:message controller:controller sel:nil];
}

- (void) setDetailAmount:(UILabel *) label amount:(NSNumber *) amount{
    amount = [Util toNumber:amount];
    float amountFloat = amount.floatValue;
    if(amountFloat>0||amountFloat<0){
        label.text = [Util numberToString:amount];
    }
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
        if(self && [self respondsToSelector:sel]){
            [self performSelector:sel];
        }
    }];
    [alert addAction:action];
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
