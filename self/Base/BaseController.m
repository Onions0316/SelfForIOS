//
//  BaseController.m
//  singeViewTest
//
//  Created by roy on 16/1/6.
//  Copyright © 2016年 roy. All rights reserved.
//

#import "BaseController.h"
#import "AccountInfoManager.h"
#import "UIAlertViewTool.h"

#define TitleTag 9001

@interface BaseController()<UIAlertViewDelegate>

@property (nonatomic,assign) BOOL showState;
@property (nonatomic,strong) UIView * navView;
@property (nonatomic,assign) int titleButtonCount;
@property (nonatomic,assign) int titleTop;
@property (nonatomic,assign) SEL oldSel;

@end

@implementation BaseController

@synthesize logName;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id) init{
    if(self=[super init]){
        logName = @"Base";
        _showBack = YES;
        _checkLogin = YES;
        _showLogout = [[AccountInfoManager sharedInstance] hasLogin];
        _showState = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0");
        _titleButtonCount = 0;
    }
    return self;
}

-(void) viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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
            [UIUtil addButtonInView:self.navView image:[UIImage imageNamed:@"back"] rect:backRect sel:@selector(clickBack) controller:self tag:0];
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
            [UIUtil addButtonInView:self.navView image:[UIImage imageNamed:@"logout"] rect:backRect sel:@selector(logout) controller:self tag:0];
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
    [UIUtil addButtonInView:self.navView image:[UIImage imageNamed:imageName] rect:rect sel:sel controller:self tag:0];
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
            lblTitle = [UIUtil addLableInView:self.navView text:navTitle rect:rect tag:TitleTag];
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
        UIViewController * controller = [[goClass alloc] init];
        [self goController:controller];
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
//注销
- (void) logout{
    [[AccountInfoManager sharedInstance] logout:self];
}

- (void) logStr:(NSString*) logStr{
    NSLog(@"%@ log :%@",self.logName,logStr);
}

//设置金额
- (void) setDetailAmount:(UILabel *) label amount:(float) amount{
    label.text = [Util numberToString:fabsf(amount)];
    if(amount>0){
        label.textColor = [UIColor blueColor];
    }else if(amount <0){
        label.textColor =[UIColor redColor];
    }
}
- (void) showAlert:(NSString *)title
            message:(NSString *)message
               sel:(SEL) sel{
    UIAlertViewTool * alert = [[UIAlertViewTool alloc] initWithDelegate:self];
    [alert showAlert:title message:message sel:sel];
}

- (void)showAlert:(NSString *)title message:(NSString *)message sel:(SEL)sel leftText:(NSString *)leftText rightText:(NSString *)rightText{
    UIAlertViewTool * alert = [[UIAlertViewTool alloc] initWithDelegate:self];
    [alert showAlert:title message:message sel:sel leftText:leftText rightText:rightText];
}

@end
