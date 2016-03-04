//
//  ApiResponse.h
//  Links
//
//  Created by zeppo on 14-5-24.
//  Copyright (c) 2014年 zhengpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiResponse : NSObject
@property (nonatomic,assign) BOOL isSuccess;
@property (nonatomic,strong) id result;
@property (nonatomic,strong) NSString *failCode;
@property (nonatomic,strong) NSString *failMessage;
@end
