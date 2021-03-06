//
//  Util.m
//  self
//
//  Created by roy on 16/2/25.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "Util.h"

@implementation Util


/*
 *  获取系统文档路径
 */
+ (NSString *) documentPath{
    //NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    //return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    return [self homePath:@"Documents"];
}

/*
 *  获取系统路径
 */
+ (NSString *) homePath:(NSString *)path{
    return [NSHomeDirectory() stringByAppendingPathComponent:path];
}

/*
 *  获取当前时间秒
 */
+ (NSNumber *) nowTime{
    NSDate * now = [NSDate date];
    //当前时间毫秒
    NSInteger nowTime = [now timeIntervalSince1970];
    //时区毫秒
    //NSInteger zoneTime =[[NSTimeZone systemTimeZone] secondsFromGMT];
    return [NSNumber numberWithInteger:nowTime];
}

/*
 *  获取当前时间
 */
+ (NSDate *) nowDate{
    return [self timeToDate:[self nowTime]];
}

/*
 *  获取秒对应的时间
 */
+ (NSDate *) timeToDate:(NSNumber *) time{
    return [NSDate dateWithTimeIntervalSince1970:[time integerValue]];
}

/*
 *  获取日期对应格式的字符串
 */
+ (NSString *) dateToString:(NSDate *) date format:(NSString *) format{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}
/*
 *  获取字符串对应日期
 */
+ (NSDate *) stringToDate:(NSString *) string format:(NSString *) format{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    if(![format hasValue]){
        format = Default_Date_Time_Format;
    }
    [formatter setDateFormat:format];
    return [formatter dateFromString:string];
}

+ (NSNumber *) toNumber:(id) obj{
    NSString * string = [NSString stringWithFormat:@"%@",obj];
    NSNumberFormatter * format = [[NSNumberFormatter alloc] init];
    return [format numberFromString:string];
}

+ (NSString *) numberToString:(float) number{
    //NSNumberFormatter * format = [[NSNumberFormatter alloc] init];
    //format.numberStyle = NSNumberFormatterCurrencyStyle;
    //return [format stringFromNumber:[NSNumber numberWithFloat:number]];
    return [[NSString stringWithFormat:@"%f",number] thousandNumber];
}

+ (NSString *) numberToString:(float) number formatter:(NSNumberFormatterStyle) formatter{
    NSNumberFormatter * format = [[NSNumberFormatter alloc] init];
    format.numberStyle = formatter;
    return [format stringFromNumber:[NSNumber numberWithFloat:number]];
}

/**获取路径文件的minitype*/
+ (NSString *)mimeTypeForPath:(NSString *)path
{
    // get a mime type for an extension using MobileCoreServices.framework
    
    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    assert(UTI != NULL);
    
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    assert(mimetype != NULL);
    
    CFRelease(UTI);
    
    return mimetype;
}
@end