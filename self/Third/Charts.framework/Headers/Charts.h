//
//  Charts.h
//  Charts
//
//  Created by roy on 16/5/18.
//  Copyright © 2016年 onions. All rights reserved.
//


#include <TargetConditionals.h>

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

//! Project version number for Charts.
FOUNDATION_EXPORT double ChartsVersionNumber;

//! Project version string for Charts.
FOUNDATION_EXPORT const unsigned char ChartsVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Charts/PublicHeader.h>


