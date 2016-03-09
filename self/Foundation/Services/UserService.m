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

/*
 *  统计方法
 */
- (User *) total:(User *) user{
    User * result;
    if(user && user.user_id>0){
        NSString * dtField = @"dt";
        NSString * amountField = @"amount";
        NSString * query = [NSString stringWithFormat:@"select detail_type as %@,sum(amount) as %@ from detail where user_id='%@' group by detail_type",dtField,amountField,user.user_id];
        NSArray * list = [[super db] selectData:query];
        user.totle_in=@0;
        user.totle_out=@0;
        for(id l in list){
            if([l isKindOfClass:[NSDictionary class]]){
                NSDictionary * dic = (NSDictionary *)l;
                NSNumber * key = [Util toNumber:[dic objectForKey:dtField]];
                if(key){
                    NSNumber * amount = [Util toNumber:[dic objectForKey:amountField]];
                    if(amount){
                        int keyInt = key.intValue;
                        if(keyInt>0){
                            user.totle_in = amount;
                        }
                        else if(keyInt<0){
                            user.totle_out = amount;
                        }
                    }
                }
            }
        }
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
