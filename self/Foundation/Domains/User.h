//
//  User.h
//  self
//
//  Created by roy on 16/2/29.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "BaseDomain.h"

#ifndef User_h
#define User_h
/*
 *  用户性别
 */
typedef NS_ENUM (NSInteger,ESex){
    Man,
    Woman
};
/**
 *  用户类型
 */
@interface User : BaseDomain

CREATE_TYPE_PROPERTY(NSNumber,user_id)
CREATE_TYPE_PROPERTY(NSString,real_name)
CREATE_TYPE_PROPERTY(NSString,name)
CREATE_TYPE_PROPERTY(NSString,password)

@property (nonatomic,assign) ESex sex;

CREATE_TYPE_PROPERTY(NSNumber,birthday)
//
CREATE_TYPE_PROPERTY(NSNumber,totle_in)
//
CREATE_TYPE_PROPERTY(NSNumber,totle_out)
//
CREATE_TYPE_PROPERTY(NSNumber,totle_all)

CREATE_TYPE_PROPERTY(NSNumber, last_total_time)

@end

#endif /* User_h */
