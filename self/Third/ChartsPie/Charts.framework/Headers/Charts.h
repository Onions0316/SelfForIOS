//
//  Charts.h
//  Charts
//
//  Created by 彭颖 on 16/9/1.
//  Copyright © 2016年 DLC. All rights reserved.
//

#include <TargetConditionals.h>

#if TARGET_OS_IPHONE || TARGET_OS_TV || TARGET_IPHONE_SIMULATOR
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

//! Project version number for Charts.
FOUNDATION_EXPORT double ChartsVersionNumber;

//! Project version string for Charts.
FOUNDATION_EXPORT const unsigned char ChartsVersionString[];
