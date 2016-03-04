//
//  NSString+.m
//  self
//
//  Created by roy on 16/3/3.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "NSString+.h"

@implementation NSString (Self_Ext)

/*
 *  去掉字符串内所有空格
 */
- (NSString *) stringByCutEmpty{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

/*
 *  字符串判空
 */
- (BOOL) hasValue{
    return self && [self stringByCutEmpty].length>0;
}

@end