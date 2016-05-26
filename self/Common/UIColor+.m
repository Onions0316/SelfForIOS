//
//  UIColor+.m
//  self
//
//  Created by roy on 16/5/26.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "UIColor+.h"

@implementation UIColor (ext)

+ (UIColor *) colorWithHex:(uint) hex alpha:(CGFloat)alpha
{
    NSInteger red, green, blue;
    
    blue = hex & 0x0000FF;
    green = ((hex & 0x00FF00) >> 8);
    red = ((hex & 0xFF0000) >> 16);
    
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}


@end
