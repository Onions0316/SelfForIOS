//
//  UIAlertViewTool.m
//  SharpEyes
//
//  Created by 彭颖 on 16/8/12.
//  Copyright © 2016年 DLC. All rights reserved.
//

#import "UIAlertViewTool.h"
#import "Single.h"

@interface UIAlertViewTool()<UIAlertViewDelegate>

@property (nonatomic,assign) SEL oldSel;
@property (nonatomic,assign) id delegate;


@end

@implementation UIAlertViewTool

- (instancetype)initWithDelegate: (id) delegate{
    if(self=[super init]){
        _delegate = delegate;
    }
    return self;
}

#pragma mark ~9.0 alert
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(self.oldSel && [self.delegate respondsToSelector:self.oldSel]){
        [self.delegate performSelector:self.oldSel withObject:[NSNumber numberWithInteger:buttonIndex]];
        self.oldSel = nil;
    }
}

#pragma mark 9.0~ alert
- (void) showAlert:(NSString *)title
           message:(NSString *)message
               sel:(SEL) sel{
    [self showAlert:title message:message sel:sel leftText:nil rightText:nil];
}

- (void) showAlert:(NSString *)title
           message:(NSString *)message
               sel:(SEL) sel
            leftText:(NSString *)leftText
         rightText:(NSString *)rightText{
    if(self.delegate){
        if([Single sharedInstance].lessThanIOS9 || ![self.delegate isKindOfClass:[UIViewController class]]){
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title
                                                             message:message
                                                            delegate:self.delegate
                                                   cancelButtonTitle:leftText
                                                   otherButtonTitles:rightText,nil];
            alert.delegate = self;
            self.oldSel = sel;
            [alert show];
        }else{
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            if(leftText){
                UIAlertAction * action = [UIAlertAction actionWithTitle:leftText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                    if(sel && [self.delegate respondsToSelector:sel]){
                        [self.delegate performSelector:sel withObject:@0];
                    }
                }];
                [alert addAction:action];
            }
            if(![rightText hasValue]){
                rightText = @"确定";
            }
            UIAlertAction * action = [UIAlertAction actionWithTitle:rightText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                if(sel && [self.delegate respondsToSelector:sel]){
                    [self.delegate performSelector:sel withObject:@1];
                }
            }];
            [alert addAction:action];
            [self.delegate presentViewController:alert animated:true completion:nil];
        }
    }
}
@end
