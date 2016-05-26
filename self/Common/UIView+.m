//
//  UIView+.m
//  self
//
//  Created by roy on 16/5/26.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "UIView+.h"

#define LoadTag 9999

@implementation UIView(ext)
#pragma mark frame
- (CGSize) size{
    return self.frame.size;
}

- (CGPoint) origin{
    return self.frame.origin;
}

- (CGFloat)width{
    return [self size].width;
}

- (void)setWidth:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (CGFloat)height{
    return [self size].height;
}

- (void)setHeight:(CGFloat)height{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGFloat)top{
    return [self origin].y;
}

-(void)setTop:(CGFloat)top{
    CGRect rect = self.frame;
    rect.origin.y = top;
    self.frame = rect;
}

- (CGFloat)left{
    return [self origin].x;
}

- (void)setLeft:(CGFloat)left{
    CGRect rect = self.frame;
    rect.origin.x = left;
    self.frame = rect;
}

- (CGFloat)bottom{
    return self.top+self.height;
}

- (void)setBottom:(CGFloat)bottom{
    self.top = bottom - self.height;
}

- (CGFloat)right{
    return self.left + self.width;
}

- (void)setRight:(CGFloat)right{
    self.left = right - self.width;
}

- (CGFloat)centerX{
    return self.left + self.width/2;
}

- (void)setCenterX:(CGFloat)centerX{
    self.left = centerX - self.width/2;
}

- (CGFloat)centerY{
    return self.top + self.height/2;
}

- (void)setCenterY:(CGFloat)centerY{
    self.top = centerY - self.height/2;
}


#pragma mark loading
///显示统计遮罩
- (void) showLoading{
    //
    UIView *view = (UIView*)[self viewWithTag:LoadTag];
    if(view==nil){
        CGSize size = self.frame.size;
        //创建半透明层
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [view setTag:LoadTag];
        [view setBackgroundColor:[UIColor grayColor]];
        [view setAlpha:0.3];
        
        UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
        [activityIndicator setCenter:view.center];
        [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [view addSubview:activityIndicator];
        
        [self addSubview:view];
    }
    view.hidden = NO;
    UIActivityIndicatorView * ai = view.subviews.firstObject;
    if(ai){
        [ai startAnimating];
    }
}
///影藏遮罩
- (void) hideLoading{
    UIView *view = (UIView*)[self viewWithTag:LoadTag];
    if(view){
        UIActivityIndicatorView * ai = view.subviews.firstObject;
        if(ai){
            [ai stopAnimating];
        }
        view.hidden = YES;
    }
}

@end
