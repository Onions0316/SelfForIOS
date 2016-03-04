//
//  HomeController.m
//  self
//
//  Created by roy on 16/2/23.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "HomeViewController.h"
#import "AccountInfoManager.h"

#define Info_Height 100
#define Operation_Height 200
@interface HomeViewController()

@property (nonatomic,assign) CGFloat top;

@end

@implementation HomeViewController

- (id) init{
    if(self=[super init]){
        super.navTitle = @"首页";
        super.showBack = NO;
    }
    return self;
}

- (void) viewDidLoad{
    [super viewDidLoad];
    
    self.top = super.topSize;
    User * user = [[AccountInfoManager sharedInstance] user];
    [self drawInfo:user];
    [self drawDetails:user];
    [self drawOpreation];
}

/*
 *  用户信息
 */
- (void) drawInfo:(User *) user{
    
    NSString * name = [user.real_name hasValue]?user.real_name:user.name;
    CGRect rect = CGRectMake(Default_View_Space, self.top+Default_View_Space, Main_Screen_Width-2*Default_View_Space, 100);
    UIView * view = [[UIView alloc] initWithFrame:rect];
    
    rect = CGRectMake(0, 0, 0, Default_Label_Height);
    [UIUtil addLableInView:view text:[NSString stringWithFormat:@"hello,%@",name] rect:rect tag:nil];

    [self.view addSubview:view];
}

/*
 *  收支信息
 */
- (void) drawDetails:(User *) user{}

/*
 *  操作
 */
- (void) drawOpreation{
    CGRect rect = CGRectMake(0, Main_Screen_Height-Operation_Height-Default_View_Space, Main_Screen_Width, Operation_Height);
    UIView * view = [[UIView alloc] initWithFrame:rect];
    CGFloat buttonHeight = Operation_Height - 2*Default_View_Space;
    
}

#pragma mark navigation
- (BOOL)slideNavigationControllerShouldDisplayRightMenu {
    return NO;
}
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return YES;
}


@end