//
//  NSDate+.m
//  self
//
//  Created by roy on 16/5/27.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "NSDate+.h"

@implementation NSDate(ext)

static const unsigned componentFlags = (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit);


+ (NSCalendar *) currentCalendar
{
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar)
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    return sharedCalendar;
}

- (NSDateComponents *) components{
    return [[NSDate currentCalendar] components:componentFlags fromDate:self];
}

- (NSInteger) year{
    return [self components].year;
}

-(NSInteger)month{
    return [self components].month;
}

-(NSInteger)day{
    return [self components].day;
}

-(NSInteger)hour{
    return [self components].hour;
}

-(NSInteger)minute{
    return [self components].minute;
}

-(NSInteger)second{
    return [self components].second;
}

-(NSInteger)week{
    return  [self components].week;
}

-(NSInteger) weekDay{
    return [self components].weekdayOrdinal;
}

@end
