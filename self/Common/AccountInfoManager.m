//
//  AccountInfoManager.m
//  self
//
//  Created by roy on 16/2/25.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "AccountInfoManager.h"

@interface AccountInfoManager()

@property (nonatomic,strong) NSString * infoPath;

@property (nonatomic,strong) UserService * userService;


@end

@implementation AccountInfoManager

- (id) init{
    if(self = [super init]){
        self.userService = [[UserService alloc] init];
        NSFileManager * fileManager = [NSFileManager defaultManager];
        self.infoPath = [NSString stringWithFormat:@"%@/info.plist",[Util documentPath]];
        if([fileManager fileExistsAtPath:self.infoPath]){
            NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:self.infoPath];
            if(dic){
                self.user = [DomainFactory toUser:dic];
                [self login:self.user.name password:self.user.password];
            }
        }
    }
    return self;
}

+ (AccountInfoManager *) sharedInstance{
    static dispatch_once_t pred;
    static AccountInfoManager * sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[AccountInfoManager alloc] init];
    });
    return sharedInstance;
}

- (BOOL) hasLogin{
    return self.user!=nil;
}

- (BOOL) checkLogin:(UIViewController *) controller{
    BOOL result = [self hasLogin];
    if(!result){
        [controller.navigationController pushViewController:[[LoginViewController alloc] init] animated:YES];
    }
    return result;
}

/*
 *  登录
 */
- (BOOL) login:(NSString *) name password:(NSString *) password{
    self.user = [self.userService login:name password:password];
    if(self.user){
        [self removeLoginFile];
        NSDictionary * dic = [DomainFactory dictionaryFromUser:self.user];
        //用户信息写入文件
        [dic writeToFile:self.infoPath atomically:YES];
        return YES;
    }
    return NO;
}

/*
 *  删除用户登录文件
 */
- (void) removeLoginFile{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:self.infoPath]){
        NSError * err = nil;
        BOOL success = [fileManager removeItemAtPath:self.infoPath error:&err];
        NSAssert1(success, @"file remove error", [err localizedDescription]);
    }
}

/**
 * 退出登录并删除登陆信息
 */
- (void) logout:(UIViewController *) controller{
    [self removeLoginFile];
    self.user = nil;
    [controller.navigationController pushViewController:[[LoginViewController alloc] init] animated:YES];
}


@end