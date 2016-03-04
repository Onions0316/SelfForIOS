//
//  AccountInfoManager.h
//  self
//
//  Created by roy on 16/2/25.
//  Copyright © 2016年 onions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLiteOperation.h"
#import "Util.h"
#import "UserService.h"
#import "LoginViewController.h"
#import "HomeViewController.h"

@interface AccountInfoManager : NSObject

@property (nonatomic,strong) User * user;
@property (nonatomic,strong) HomeViewController * home;

+ (AccountInfoManager *) sharedInstance;
- (BOOL) hasLogin;
- (BOOL) checkLogin:(UIViewController *) controller;
- (BOOL) login:(NSString *) name password:(NSString *) password;
- (void) logout:(UIViewController *) controller;
- (BOOL) total;
@end