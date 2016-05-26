//
//  UserService.m
//  self
//
//  Created by roy on 16/3/1.
//  Copyright © 2016年 onions. All rights reserved.
//


#import "UserService.h"
#import "DetailService.h"

@interface UserService()

@property (nonatomic,strong) DetailService * detail;

@end

/*
 *  用户方法
 */
@implementation UserService

- (instancetype)init{
    if(self=[super init]){
        self.detail = [[DetailService alloc] init];
    }
    return self;
}

/*
 *  用户登录方法
 */
- (User *) login:(NSString *) name password:(NSString *)password{
    NSString * sql = [super selectSQL:[User class] params:@{@"name":name,@"password":password}];
    NSArray * result = [super select:[User class] sql:sql];
    if(result.count==1){
        return (User *)[result firstObject];
    }
    return nil;
}

/*
 *  检查用户名是否存在 存在返回YES
 */
- (BOOL) checkName:(NSString *) name{
    NSString * sql = [super selectSQL:[User class] params:@{@"name":name}];
    NSArray * array = [super select:[User class] sql:sql];
    return array.count>0;
}

/*
 *  新增方法
 */
- (BOOL) add:(User *) user{
    NSString * sql = [super insertSQL:user];
    //NSLog(@"%@",sql);
    return [super.db eval:sql params:nil];
}

/*
 *  更新方法
 */
- (BOOL) update:(User *) user{
    NSString * sql = [super updateSQL:user];
    return [super.db eval:sql params:nil];
}

/*
 *  统计方法
 */
- (User *) total:(User *) user{
    User * result;
    if(user && user.user_id>0){
        float totalIn = 0;
        float totalOut = 0;
        NSString * query = [NSString stringWithFormat:@"from detail where user_id='%@'",user.user_id];
        [self.detail totalAll:query rin:&totalIn rout:&totalOut];
        user.totle_in = @(totalIn);
        user.totle_out = @(totalOut);
        user.totle_all = [NSNumber numberWithFloat:user.totle_in.floatValue-user.totle_out.floatValue];
        //更新同步时间
        user.last_total_time = [Util nowTime];
        if([self update:user]){
            result = user;
        }
    }
    return result;
}

@end
