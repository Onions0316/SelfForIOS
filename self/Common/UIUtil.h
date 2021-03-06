//
//  UIUtil.h
//  PageBaseTest
//
//  Created by roy on 16/1/25.
//  Copyright © 2016年 roy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIUtil : NSObject{
}
+ (CGSize) textSizeAtString:(NSString *) str font:(UIFont *)font;

+ (CGFloat) textMaxWidth:(NSArray *) arr
                    font:(UIFont *) font;
/*
 *  添加配对的描述与输入框
 */
+ (UITextField *) addLabelTextFiledInView:(UIView *) view
                                     text:(NSString *) text
                                     rect:(CGRect) rect
                                      tag:(NSInteger) tag;

+ (UILabel *) labelLineSpace:(UILabel *) label lineSpace:(CGFloat) lineSpace;

+ (UILabel *)labelManyNumberOfLines:(UILabel *)label maxWidth: (CGFloat) maxWidth;

+ (UILabel *)labelManyNumberOfLines:(UILabel *)label maxWidth: (CGFloat) maxWidth maxNum:(int) maxNum;
/*
 *  创建文本输入框
 */
+ (UITextField *) addTextFiledInView:(UIView *) view
                                rect:(CGRect) rect
                                 tag:(NSInteger) tag;
/*
 *  添加文本框自定义视图
 */
+ (void) addTextFildInputView:(UITextField *) textField
                    inputView:(UIView *) inputView
                   controller:(UIViewController *) controller
                         done:(SEL) done
                       cancel:(SEL)cancel;
/*
 * 创建描述框
 */
+ (UILabel *) addLableInView:(UIView *) view
                        text:(NSString *) text
                        rect:(CGRect) rect
                         tag:(NSInteger) tag;

+ (UILabel *) addLableInView:(UIView *) view
                        text:(NSString *) text
                        font:(UIFont*) font
                        rect:(CGRect) rect
                         tag:(NSInteger) tag;
/*
 *  创建文字按钮
 */
+ (UIButton *) addButtonInView:(UIView *) view
                         title:(NSString *) title
                          rect:(CGRect) rect
                           sel:(SEL) sel
                    controller:(id) controller
                           tag:(NSInteger) tag;
/*
 *  创建图片按钮
 */
+ (UIButton *) addButtonInView:(UIView *) view
                         image:(UIImage *) image
                          rect:(CGRect) rect
                           sel:(SEL) sel
                    controller:(id) controller
                           tag:(NSInteger) tag;
/*
 *  创建按钮
 */
+ (UIButton *) addButtonInView:(UIView *) view
                          rect:(CGRect) rect
                           sel:(SEL) sel
                    controller:(id) controller
                           tag:(NSInteger) tag;
/*
 *  添加视图到视图
 */
+(void) addViewInView:(UIView *) view
              subview:(UIView *) subview
                  tag:(NSInteger) tag;
@end