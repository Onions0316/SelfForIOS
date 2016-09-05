//
//  UIImage+.h
//  self
//
//  Created by 彭颖 on 16/9/5.
//  Copyright © 2016年 onions. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIImage(ext)

/**通过颜色创建图片*/
+ (UIImage *) imageWithColor:(UIColor*)color;
/**创建二维码*/
+ (UIImage*) createARCode:(NSString *) url;
+ (UIImage*) createARCode:(NSString *) url withSize:(CGFloat) size beforColor:(UIColor *) beforColor backColor:(UIColor *) backColor;
@end
