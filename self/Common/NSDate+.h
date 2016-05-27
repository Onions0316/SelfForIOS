//
//  NSDate+.h
//  self
//
//  Created by roy on 16/5/27.
//  Copyright © 2016年 onions. All rights reserved.
//

#ifndef NSDate__h
#define NSDate__h

#import <Foundation/Foundation.h>

@interface NSDate(ext)

- (NSInteger) year;
- (NSInteger) month;
- (NSInteger) day;
- (NSInteger) hour;
- (NSInteger) minute;
- (NSInteger) second;
- (NSInteger) week;
- (NSInteger) weekDay;

@end

#endif /* NSDate__h */
