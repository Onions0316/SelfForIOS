//
//  PublicNavigationViewController.m
//  SharpEyes
//
//  Created by 彭颖 on 16/8/25.
//  Copyright © 2016年 DLC. All rights reserved.
//

#import "PublicNavigationViewController.h"

@implementation PublicNavigationViewController

-(BOOL)shouldAutorotate{
    return [self.topViewController shouldAutorotate];
}
//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

@end
