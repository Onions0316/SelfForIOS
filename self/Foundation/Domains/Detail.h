//
//  Detail.h
//  self
//
//  Created by roy on 16/2/29.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "BaseDomain.h"

#ifndef Detail_h
#define Detail_h
/*
 *  收支类型
 */
typedef NS_ENUM(NSInteger,EDetailType){
    Out=-1,
    In = 1
};

/*
 *  用户收支明细
 */
@interface Detail : BaseDomain

CREATE_TYPE_PROPERTY(NSNumber,detail_id)
CREATE_TYPE_PROPERTY(NSNumber,user_id)

@property (nonatomic,assign) EDetailType detail_type;

CREATE_TYPE_PROPERTY(NSNumber,amount)
CREATE_TYPE_PROPERTY(NSNumber,happen_time)
CREATE_TYPE_PROPERTY(NSString,memo)

@end

#endif /* Detail_h */
