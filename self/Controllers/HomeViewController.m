//
//  HomeController.m
//  self
//
//  Created by roy on 16/2/23.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "HomeViewController.h"
#import "AddDetailViewController.h"
#import "UserService.h"
#import "DetailService.h"
#import "SearchViewController.h"
#import "RegisterViewController.h"
#import "StatisticViewController.h"

#define Info_Height 50
#define Details_Height 200

#define Tag_User_Total_In 2001
#define Tag_User_Total_Out 2002
#define Tag_User_Total_All 2003
#define Tag_User_Total_Time 2004
#define Tag_User_Count 2005
#define Tag_User_Hello 2006

@interface HomeViewController()

@property (nonatomic,assign) CGFloat top;
CREATE_TYPE_PROPERTY_TO_VIEW(UIView, detailView)
CREATE_TYPE_PROPERTY_TO_VIEW(UIView, infoView)

CREATE_TYPE_PROPERTY_TO_VIEW(UserService, userService)
CREATE_TYPE_PROPERTY_TO_VIEW(DetailService, detailService)

@property (nonatomic,assign) BOOL totaling;

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
    self.totaling = NO;
    self.userService = [[UserService alloc] init];
    self.detailService = [[DetailService alloc] init];
    self.top = super.topSize;
    User * user = [[AccountInfoManager sharedInstance] user];
    [self drawInfo:user];
    [self drawDetails:user];
    [self drawOperation];
    [super addTitleButton:@"edit" sel:@selector(updateUser)];
    //创建更新数据通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHomeNotification:) name:NotificationHomeUpdate object:nil];
}
/*
 *  编辑用户信息
 */
- (void) updateUser{
    RegisterViewController * controller = [[RegisterViewController alloc] init];
    controller.updateUser = [AccountInfoManager sharedInstance].user;
    [super goController:controller];
}
//获取欢迎语并设置标题
- (NSString *) helloString:(User *) user{
    NSMutableString * result = [[NSMutableString alloc] init];
    NSString * name = [user.real_name hasValue]?user.real_name:user.name;
    [result appendFormat:@"您好,%@%@",name,user.sex==Man?@"先生":@"女士"];
    NSString * navTitle = @"";
    if(user.birthday){
        NSString * today = [Util dateToString:[Util nowDate] format:Default_Day_Format];
        NSString * birthday = [Util dateToString:[Util timeToDate:user.birthday] format:Default_Day_Format];
        if([birthday isEqualToString:today]){
            navTitle = @"生日快乐";
        }
    }
    if(navTitle.length==0){
        NSInteger times = [Util nowTime].integerValue-user.create_time.integerValue;
        int timeToDay = 24*60*60;
        NSInteger days = (times+timeToDay-1)/timeToDay;
        navTitle = [NSString stringWithFormat:@"第%ld天",(long)days];
    }
    if(navTitle.length>0){
        [super updateTitle:navTitle];
    }
    return result;
}

- (void) updateHello:(User *) user{
    UILabel * label = [self.infoView viewWithTag:Tag_User_Hello];
    label.text = [self helloString:user];
}

/*
 *  用户信息
 */
- (void) drawInfo:(User *) user{
    self.top+=Default_View_Space;
    CGFloat viewLeft = 3*Default_View_Space;
    CGFloat viewWidth = Main_Screen_Width-2*viewLeft;
    CGRect rect = CGRectMake(viewLeft, self.top, viewWidth, Info_Height);
    UIView * view = [[UIView alloc] initWithFrame:rect];
    
    CGFloat nowY = 0;
    rect = CGRectMake(0, nowY, viewWidth, Default_Label_Height);
    UILabel * hello = [UIUtil addLableInView:view text:[self helloString:user] rect:rect tag:Tag_User_Hello];
    hello.textAlignment = NSTextAlignmentLeft;
    nowY += Default_Label_Height;

    NSNumber * count = [self.detailService count:user.user_id];
    if(count){
        NSString * countString = [NSString stringWithFormat:@"您实时数据条数为:"];
        rect.origin.y = nowY;
        rect.size.width = 0;
        UILabel * label = [UIUtil addLableInView:view text:countString rect:rect tag:0];
        //rect = label.frame;
        rect.origin.x += label.frame.size.width;
        [UIUtil addLableInView:view text:[Util numberToString:count.floatValue formatter:NSNumberFormatterDecimalStyle] rect:rect tag:Tag_User_Count];
    }
    self.top+=Info_Height;
    self.infoView = view;
    [self.view addSubview:view];
}
/*
 *  更新总数据条数
 */
- (void) updateCount{
    UILabel * countLabel = [self.infoView viewWithTag:Tag_User_Count];
    NSNumber * count = [self.detailService count:[AccountInfoManager sharedInstance].user.user_id];
    NSString * countString = [Util numberToString:count.floatValue formatter:NSNumberFormatterDecimalStyle];
    CGSize size = [UIUtil textSizeAtString:countString font:Default_Font];
    CGRect rect = countLabel.frame;
    rect.size.width = size.width;
    countLabel.frame = rect;
    countLabel.text = countString;
}

/*
 *  设置收支明细值
 */
- (void) setDetails:(User *) user{
    UILabel * inLabel = [self.detailView viewWithTag:Tag_User_Total_In];
    [super setDetailAmount:inLabel amount:user.totle_in.floatValue];
    UILabel * outLabel = [self.detailView viewWithTag:Tag_User_Total_Out];
    [super setDetailAmount:outLabel amount:user.totle_out.floatValue];
    outLabel.textColor = [UIColor redColor];
    UILabel * allLabel = [self.detailView viewWithTag:Tag_User_Total_All];
    [super setDetailAmount:allLabel amount:user.totle_all.floatValue];
    UILabel * timeLabel = [self.detailView viewWithTag:Tag_User_Total_Time];
    if(user.last_total_time){
        NSString * memo = [Util dateToString:[Util timeToDate:user.last_total_time] format:Default_Date_Time_Format];
        CGRect rect = timeLabel.frame;
        CGSize size = [UIUtil textSizeAtString:memo font:Default_Font];
        rect.size.width = size.width;
        timeLabel.text = memo;
        timeLabel.frame = rect;
    }
}

/*
 *  收支信息
 */
- (void) drawDetails:(User *) user{
    self.top+=Default_View_Space;
    CGFloat viewLeft = Default_View_Space*3;
    CGFloat viewWidth = Main_Screen_Width-2*viewLeft;
    CGRect rect = CGRectMake(viewLeft, self.top,viewWidth , Details_Height);
    self.detailView = [[UIView alloc] initWithFrame:rect];
    
    NSArray * fields = @[User_Totle_In,User_Totle_Out,User_Totle_All];
    CGFloat labelWidth = [UIUtil textMaxWidth:fields font:Default_Font];
    UIFont * detailFont = [UIFont systemFontOfSize:25];
    CGFloat detailHeight = [UIUtil textSizeAtString:@"0" font:detailFont].height;
    rect.size.height = detailHeight*3;
    //重设view高度
    self.detailView.frame = rect;
    CGFloat lableTop = (detailHeight - Default_Label_Height)/2;
    CGFloat detailTop = 0;
    CGFloat tagIndex = Tag_User_Total_In;
    CGFloat detailX = labelWidth+Default_View_Space;
    //设置同步时间
    rect = CGRectMake(0, lableTop, 0, Default_Label_Height);
    [UIUtil addLableInView:self.detailView text:@"您上次统计时间为:" rect:rect tag:0];
    rect.origin.y += Default_Label_Height;
    [UIUtil addLableInView:self.detailView text:@"" rect:rect tag:Tag_User_Total_Time];
    
    rect.origin.y +=  Default_Label_Height+Default_View_Space;
    
    detailTop+=rect.origin.y;
    lableTop +=rect.origin.y;
    
    for(NSString * str in fields){
        rect = CGRectMake(0, lableTop, labelWidth, Default_Label_Height);
        [UIUtil addLableInView:self.detailView text:str rect:rect tag:0];
        rect = CGRectMake(detailX, detailTop, viewWidth-detailX, detailHeight);
        [UIUtil addLableInView:self.detailView text:@"" font:detailFont rect:rect tag:tagIndex];
        lableTop+=detailHeight;
        detailTop+=detailHeight;
        tagIndex++;
    }
    [self setDetails:user];
    rect = self.detailView.frame;
    rect.size.height = detailTop;
    self.detailView.frame = rect;
    self.top+=self.detailView.frame.size.height;
    [self.view addSubview:self.detailView];
}

/*
 *  操作
 */
- (void) drawOperation{
    CGFloat viewHeight = Main_Screen_Height-self.top;
    CGFloat viewLeft = 0;
    if(viewHeight>Main_Screen_Width){
        viewHeight = Main_Screen_Width;
    }else{
        viewLeft = (Main_Screen_Width-viewHeight)/2;
    }
    CGRect rect = CGRectMake(viewLeft, self.top, viewHeight, viewHeight);
    int cols = 2;
    CGFloat imageLeft = Default_View_Space;
    CGFloat imageWidth = (viewHeight-(cols+1)*imageLeft)/cols;
    UIView * view = [[UIView alloc] initWithFrame:rect];
    
    NSString * name = @"name";
    NSString * select = @"selector";
    
    NSArray * arr = @[@{name:@"add",select:@"add"},
                      @{name:@"search",select:@"search"},
                      @{name:@"refresh",select:@"totalData"},
                      @{name:@"statistic",select:@"statistic"}];
    
    CGFloat left = 0;
    CGFloat top = imageLeft;
    
    for(int i=0;i<arr.count;i++){
        if(i%cols==0){
            left = imageLeft;
            if(i>0){
                top += imageLeft + imageWidth;
            }
        }
        rect = CGRectMake(left, top, imageWidth, imageWidth);
        NSDictionary * dic = arr[i];
        [UIUtil addButtonInView:view image:[UIImage imageNamed:dic[name]] rect:rect sel:NSSelectorFromString(dic[select]) controller:self tag:0];
        left+=imageLeft+imageWidth;
    }
    
    [self.view addSubview:view];
}


#pragma mark operation
/*
 *  添加明细
 */
- (void) add{
    [super goController:[[AddDetailViewController alloc] init]];
}

- (void) search{
    [super goController:[[SearchViewController alloc] init]];
}

//更新数据通知
- (void) updateHomeNotification:(NSNotification*)notification{
    if([Single sharedInstance].isTotal){
        [self updateCount];
        [self totalData];
        [Single sharedInstance].isTotal = NO;
    }
    [self updateHello:[AccountInfoManager sharedInstance].user];
}

- (void) totalData{
    if(!self.totaling){
        self.totaling = YES;
        [self.detailView showLoading];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            User * user =  [self.userService total:[AccountInfoManager sharedInstance].user];
            if(user){
                [AccountInfoManager sharedInstance].user =user;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setDetails:[AccountInfoManager sharedInstance].user];
                [self.detailView hideLoading];
                self.totaling = NO;
            });
        });
    }
}

- (void) statistic{
    [super goController:[[StatisticViewController alloc] init]];
}

@end