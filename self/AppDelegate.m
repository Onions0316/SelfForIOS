//
//  AppDelegate.m
//  self
//
//  Created by roy on 16/2/23.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "AccountInfoManager.h"
#import "Single.h"
#import "MyExceptionCrash.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //异常捕捉
    InstallUncaughtExceptionHandler();
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    SQLiteOperation * db = [[Single sharedInstance] db];
    //装载数据库初始化语句
    NSString * path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"dbInit.txt"];
    db.dbInitSql = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"%@",db.path);
    [db readyDatabase];
    //首页装载
    /* SlideNavigationController * home = [[SlideNavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    //home.navigationBar.hidden = YES;
    //home.enableShadow = NO;
    */
    HomeViewController * home = [[HomeViewController alloc] init] ;
    UINavigationController * main = [[UINavigationController alloc] initWithRootViewController:home];
    main.navigationBarHidden = YES;
    self.window.rootViewController = main;
    
    //设置状态栏字体颜色 需要在info plist 里设置View controller-based status bar appearance 为no
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.window makeKeyAndVisible];
    //NSLog(@"%f",[UIUtil textMaxWidth:@[User_Name,User_Real_Name,Detail_Happen_Time] font:Default_Font]);
    //[[AccountInfoManager sharedInstance] login:@"test1" password:@"123456"];
    
    //[[AccountInfoManager sharedInstance] logout];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
