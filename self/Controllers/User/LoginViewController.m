//
//  LoginViewController.m
//  self
//
//  Created by roy on 16/3/2.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "DomainFactory.h"
#import "UserService.h"
#import "AccountInfoManager.h"
#import "HomeViewController.h"

@interface LoginViewController()

CREATE_TYPE_PROPERTY_TO_VIEW(UITextField, name)
CREATE_TYPE_PROPERTY_TO_VIEW(UITextField, password)

CREATE_TYPE_PROPERTY_TO_VIEW(UserService, userService)

@end

@implementation LoginViewController

- (id) init{
    if(self=[super init]){
        super.navTitle = Login;
        super.showBack = NO;
        super.checkLogin = NO;
    }
    return self;
}

- (void) viewDidLoad{
    [super viewDidLoad];
    
    self.userService = [[UserService alloc] init];
    
    CGFloat top = super.topSize;
    CGFloat viewTop = (Main_Screen_Height-top)/3+top;
    //label最大宽度
    CGFloat maxLableWidth = [UIUtil textMaxWidth:@[User_Name,User_Password] font:Default_Font];
    //容器宽度
    CGFloat viewWidth = maxLableWidth+10+Default_TextFiled_Width;
    //容器x坐标
    CGFloat viewX = (Main_Screen_Width-viewWidth)/2;
    CGRect viewRect = CGRectMake(viewX, viewTop, viewWidth, Main_Screen_Height-viewTop);
    UIView * view = [[UIView alloc] initWithFrame:viewRect];
    //用户名输入框坐标
    viewRect = CGRectMake(0, 0, maxLableWidth, Default_Label_Height);
    self.name=[UIUtil addLabelTextFiledInView:view text:User_Name rect:viewRect tag:nil];
    self.name.placeholder = User_Name_Memo;
    [self.name addTarget:self action:@selector(textFiledDidEdit:) forControlEvents:UIControlEventEditingDidEnd];
    //密码输入框坐标
    viewRect.origin.y +=Default_Label_Height + Default_View_Space;
    self.password = [UIUtil addLabelTextFiledInView:view text:User_Password rect:viewRect tag:nil];
    self.password.placeholder = User_Password_Memo;
    self.password.secureTextEntry = YES;
    //登录按钮坐标
    viewRect.origin.y+=Default_Label_Height+Default_View_Space;
    viewRect.size.width = (viewWidth-Default_View_Space)/2;
    [UIUtil addButtonInView:view title:Login rect:viewRect sel:@selector(login) controller:self tag:nil];
    //注册按钮坐标
    viewRect.origin.x += viewRect.size.width+Default_View_Space;
    [UIUtil addButtonInView:view title:Register rect:viewRect sel:@selector(goRegister) controller:self tag:nil];
    
    [UIUtil addViewInView:self.view subview:view tag:nil];
}

/*
 *  去空格
 */
- (void) textFiledDidEdit:(UITextField *) sender{
    sender.text = [[sender.text stringByCutEmpty] lowercaseString];
}

- (void) login{
    NSString * nameString = [self.name.text stringByCutEmpty];
    if([nameString hasValue]){
        NSString * passwrodString = [self.password.text stringByCutEmpty];
        if([passwrodString hasValue]){
            if([[AccountInfoManager sharedInstance] login:nameString password:passwrodString]){
                [super goController:[[HomeViewController alloc] init]];
            }else{
                [super showAlert:Alert_Error message:@"用户名或密码错误,请重试" controller:nil];
            }
        }
        else{
            [super showAlert:Alert_Warning message:@"请输入密码" controller:nil];
        }
    }else{
        [super showAlert:Alert_Warning message:@"请输入用户名" controller:nil];
    }
}
/*
 *  去注册页面
 */
- (void) goRegister{
    [super goControllerByClass:[RegisterViewController class]];
}

@end