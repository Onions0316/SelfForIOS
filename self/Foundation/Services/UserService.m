//
//  UserService.m
//  self
//
//  Created by roy on 16/3/1.
//  Copyright © 2016年 onions. All rights reserved.
//


#import "UserService.h"
/*
 *  用户方法
 */
@implementation UserService

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

@end
