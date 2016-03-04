//
//  ApiResponse.m
//  Links
//
//  Created by zeppo on 14-5-24.
//  Copyright (c) 2014年 zhengpeng. All rights reserved.
//

#import "ApiResponse.h"

@implementation ApiResponse

- (NSString *) description{
    NSString * result = @"";
    if([self.result isKindOfClass:[NSDictionary class]]){
        result = ((NSDictionary*)self.result).description;
    }
    return [NSString stringWithFormat:@"state is :%@,result is :%@,code is :%@,message is :%@",self.isSuccess?@"yes":@"no",result,self.failCode,self.failMessage];
}

@end
