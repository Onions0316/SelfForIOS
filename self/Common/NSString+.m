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
    return [self stringByReplacingOccurrencesOfString:@"\\s" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}

/*
 *  字符串判空
 */
- (BOOL) hasValue{
    return self && ![[NSNull null] isEqual:self] && [self stringByCutEmpty].length>0;
}

/*
 *  去掉html标签
 */
- (NSString *)filterHTML{
    NSString * html = self;
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while (![scanner isAtEnd]) {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}
/*
 *  获取html文档类型的设置
 */
- (NSAttributedString*)htmlAttributedString{
    NSAttributedString * attr = [[NSAttributedString alloc] initWithData:[self dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    return attr;
}

///千分符
- (NSString*) thousandNumber{
    NSString * money = self;
    if(!money){
        money = @"0";
    }
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"###,##0.00"];
    return [formatter stringFromNumber:[NSNumber numberWithFloat:money.floatValue]];
}

///去掉数字修饰
- (NSString*) cutThousandNumber{
    NSMutableString * result = [[NSMutableString alloc] init];
    if(self.length>0){
        //去掉修饰符
        NSString * str = [self stringByReplacingOccurrencesOfString:@",|￥" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
        //去掉多余的0
        NSArray<NSString*> * list = [str componentsSeparatedByString:@"."];
        NSString * number = list[0];
        [result appendString:[number stringByReplacingOccurrencesOfString:@"^0*([1-9]*)" withString:@"$1" options:NSRegularExpressionSearch range:NSMakeRange(0, number.length)]];
        if(result.length==0){
            [result appendFormat:@"0"];
        }
        if(list.count>1){
            number = list[1];
            NSString * flo = [number stringByReplacingOccurrencesOfString:@"([1-9]*)0*$" withString:@"$1" options:NSRegularExpressionSearch range:NSMakeRange(0, number.length)];
            if(flo.length>0){
                [result appendFormat:@".%@",flo];
            }
        }
    }
    return result;
}

/*
 *  保蜂银行卡格式化
 */
- (NSString*) bankCard{
    NSMutableString * result = [@"" mutableCopy];
    int start=0;
    NSUInteger len = 4;
    NSInteger length = [self length];
    while (start<length) {
        len = MIN(len, length-start);
        NSRange range = NSMakeRange(start, len);
        if(start>0){
            [result appendString:@" "];
        }
        [result appendFormat:@"%@",[self substringWithRange:range]];
        start+=len;
    }
    return result;
}

/*
 *  保蜂银行卡格式化(加密版)
 */
- (NSString*) bankCardSecret{
    NSString * result = [self bankCard];
    return [result stringByReplacingOccurrencesOfString:@" \\d{4}(?= )" withString:@" **** " options:NSRegularExpressionSearch range:NSMakeRange(0, result.length)];
}

@end