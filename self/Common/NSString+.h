//
//  NSString+.h
//  self
//
//  Created by roy on 16/3/3.
//  Copyright © 2016年 onions. All rights reserved.
//
#import <Foundation/Foundation.h>
#ifndef NSString__h
#define NSString__h

@interface NSString (Self_Ext)

- (NSString *) stringByCutEmpty;
- (BOOL) hasValue;

- (NSString *)filterHTML;

- (NSAttributedString*)htmlAttributedString;

- (NSString*) thousandNumber;

- (NSString*) cutThousandNumber;

/*
 *  保蜂银行卡格式化
 */
- (NSString*) bankCard;

/*
 *  保蜂银行卡格式化(加密版)
 */
- (NSString*) bankCardSecret;
@end

#endif /* NSString__h */
