//
//  Util.h
//  self
//
//  Created by roy on 16/2/25.
//  Copyright © 2016年 onions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+.h"

@interface Util : NSObject
+ (NSString *) documentPath;
+ (NSString *) homePath:(NSString *) path;
+ (NSNumber *) nowTime;
+ (NSDate *) nowDate;
+ (NSDate *) timeToDate:(NSNumber *) time;
+ (NSString *) dateToString:(NSDate *) date format:(NSString *) format;
+ (NSDate *) stringToDate:(NSString *) string format:(NSString *) format;
+ (NSNumber *) toNumber:(id) obj;
+ (NSString *) numberToString:(float) number;
+ (NSString *) numberToString:(float) number formatter:(NSNumberFormatterStyle) formatter;
@end