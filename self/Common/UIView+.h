//
//  UIView+.h
//  self
//
//  Created by roy on 16/5/26.
//  Copyright © 2016年 onions. All rights reserved.
//

#ifndef UIView__h
#define UIView__h

#import <UIKit/UIKit.h>

@interface UIView (ext)

@property (nonatomic,assign) CGFloat top;
@property (nonatomic,assign) CGFloat bottom;
@property (nonatomic,assign) CGFloat left;
@property (nonatomic,assign) CGFloat right;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;

/**显示加载中*/
- (void) showLoading;
- (void) hideLoading;
/**显示自动隐藏的消息*/
- (void) showMessage:(NSString *) msg;
/**显示层*/
- (void) showView:(UIView *) view;
- (void) showView:(UIView *) view bgColor:(UIColor*) bgColor;
- (void) showView:(UIView *) view bgColor:(UIColor*) bgColor isCenter:(BOOL) isCenter;
- (void) hideView;
/**切图*/
- (UIImage *) screenShot;
@end

#endif /* UIView__h */
