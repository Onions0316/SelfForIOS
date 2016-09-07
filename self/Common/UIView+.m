//
//  UIView+.m
//  self
//
//  Created by roy on 16/5/26.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "UIView+.h"
#import "UIUtil.h"

#define LoadTag 9999
#define MessageTag 9998
#define ViewTag 9997

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
///显示loading遮罩
- (void) showLoading{
    //
    [self hideLoading];
    CGSize size = self.frame.size;
    //创建半透明层
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [view setTag:LoadTag];
    [view setBackgroundColor:[UIColor grayColor]];
    [view setAlpha:0.3];
    
    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [activityIndicator setCenter:view.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicator startAnimating];
    [view addSubview:activityIndicator];
    
    [self addSubview:view];
}
///影藏遮罩
- (void) hideLoading{
    [[self viewWithTag:LoadTag] removeFromSuperview];
}

///显示
- (void) showMessage:(NSString *) msg{
    //
    [[self viewWithTag:MessageTag] removeFromSuperview];
    CGSize size = self.frame.size;
    //创建透明层
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [view setTag:MessageTag];
    [view setBackgroundColor:[UIColor clearColor]];
    //消息显示view
    UIView * back = [[UIView alloc] init];
    UILabel * label = [UIUtil addLableInView:back text:msg font:[UIFont systemFontOfSize:[UIFont systemFontSize]] rect:CGRectZero tag:0];
    label.textColor = [UIColor whiteColor];
    back.width = label.width+20;
    back.height = label.height+10;
    label.center = CGPointMake(back.width/2, back.height/2);
    back.center = CGPointMake(view.width/2, view.height/2);
    back.backgroundColor = [UIColor blackColor];
    back.layer.cornerRadius = 5;
    back.layer.masksToBounds = YES;
    [view addSubview:back];
    [self addSubview:view];
    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        back.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

- (void) showView:(UIView *) view{
    [self showView:view bgColor:[UIColor clearColor]];
}

- (void) showView:(UIView *) view bgColor:(UIColor*) bgColor{
    [self showView:view bgColor:bgColor isCenter:YES];
}

- (void) showView:(UIView *) view bgColor:(UIColor*) bgColor isCenter:(BOOL) isCenter{
    //
    [self hideView];
    CGSize size = self.frame.size;
    //创建透明层
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    backView.tag = ViewTag;
    backView.backgroundColor = bgColor;
    if(isCenter){
        view.center = CGPointMake(backView.width/2, backView.height/2);
    }
    [backView addSubview:view];
    [self addSubview:backView];
}


- (void) hideView{
    //
    [[self viewWithTag:ViewTag] removeFromSuperview];
}

/**切图*/
- (UIImage *) screenShot{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
