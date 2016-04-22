//
//  MyExceptionCrash.h
//  self
//
//  Created by roy on 16/4/22.
//  Copyright © 2016年 onions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UncaughtExceptionHandler : NSObject{
    BOOL dismissed;
}

@end
void HandleException(NSException *exception);
void SignalHandler(int signal);
void InstallUncaughtExceptionHandler(void);

 /* MyExceptionCrash_h */
