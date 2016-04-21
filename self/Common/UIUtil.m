//
//  UIUtil.m
//  PageBaseTest
//
//  Created by roy on 16/1/25.
//  Copyright © 2016年 roy. All rights reserved.
//
#import "UIUtil.h"

@implementation UIUtil

/*
 *  获取文字对应字号的size
 */
+ (CGSize) textSizeAtString:(NSString*) str
                       font:(UIFont*)font{
    CGRect textRect = [str boundingRectWithSize:CGSizeMake(10000, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
    return textRect.size;
}

/*
 *  得到数组中最长宽度
 */
+ (CGFloat) textMaxWidth:(NSArray *) arr
                    font:(UIFont *) font{
    CGFloat result = 0;
    if(arr && arr.count>0){
        //NSMutableArray * widths = [[NSMutableArray alloc] init];
        for(NSString * str in arr){
            CGFloat width = [self textSizeAtString:str font:font].width;
            result = result>width?result:width;
        }
        //return ((NSNumber *)[widths valueForKeyPath:@"@max.floatValue"]).floatValue;
    }
    return result;
}

/*
 *  添加配对的描述与输入框
 */
+ (UITextField *) addLabelTextFiledInView:(UIView *) view
                                     text:(NSString *) text
                                     rect:(CGRect) rect
                                      tag:(NSInteger) tag{
    [self addLableInView:view text:text rect:rect tag:0];
    rect.origin.x+=Default_View_Space+rect.size.width;
    rect.size.width = Default_TextFiled_Width;
    return [self addTextFiledInView:view rect:rect tag:tag];
}

/*
 *  创建文本输入框
 */
+ (UITextField *) addTextFiledInView:(UIView *) view
                                rect:(CGRect) rect
                                 tag:(NSInteger) tag{
    UITextField * field = [[UITextField alloc] initWithFrame:rect];
    field.borderStyle = UITextBorderStyleRoundedRect;
    field.clearButtonMode = UITextFieldViewModeAlways;
    [self addViewInView:view subview:field tag:tag];
    return field;
}

/*
 * 创建描述框
 */
+ (UILabel *) addLableInView:(UIView *) view
                        text:(NSString *) text
                        rect:(CGRect) rect
                         tag:(NSInteger) tag{
    return [self addLableInView:view text:text font:Default_Font rect:rect tag:tag];
}

+ (UILabel *) addLableInView:(UIView *) view
                        text:(NSString *) text
                        font:(UIFont*) font
                        rect:(CGRect) rect
                         tag:(NSInteger) tag{
    CGSize size = [self textSizeAtString:text font:font];
    if(rect.size.width<size.width){
        rect.size.width = size.width;
    }
    UILabel * label = [[UILabel alloc] initWithFrame:rect];
    if(text){
        label.text = text;
        label.font = font;
        label.textAlignment = NSTextAlignmentRight;
    }
    [self addViewInView:view subview:label tag:tag];
    return label;
}

/*
 *  创建文字按钮
 */
+ (UIButton *) addButtonInView:(UIView *) view
                         title:(NSString *) title
                          rect:(CGRect) rect
                           sel:(SEL) sel
                    controller:(id) controller
                           tag:(NSInteger) tag{
    CGSize size = [self textSizeAtString:title font:Default_Font];
    if(rect.size.width<size.width){
        rect.size.width = size.width+Default_View_Space;
    }
    UIButton * button = [self addButtonInView:view rect:rect sel:sel controller:controller tag:tag];
    if(title){
        [button setTitle:title forState:UIControlStateNormal];
    }
    return button;
}

/*
 *  创建图片按钮
 */
+ (UIButton *) addButtonInView:(UIView *) view
                         image:(UIImage *) image
                          rect:(CGRect) rect
                           sel:(SEL) sel
                    controller:(id) controller
                           tag:(NSInteger) tag{
    UIButton * button = [self addButtonInView:view rect:rect sel:sel controller:controller tag:tag];
    if(image){
        [button setImage:image forState:UIControlStateNormal];
    }
    return button;
}


/*
 *  创建按钮
 */
+ (UIButton *) addButtonInView:(UIView *) view
                          rect:(CGRect) rect
                           sel:(SEL) sel
                    controller:(id) controller
                           tag:(NSInteger) tag{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    if(view){
        [button setBackgroundColor:Default_Color];
    }
    if(sel){
        [button addTarget:controller action:sel forControlEvents:UIControlEventTouchUpInside];
    }
    [self addViewInView:view subview:button tag:tag];
    return button;
}

/*
 *  添加文本框自定义视图
 */
+ (void) addTextFildInputView:(UITextField *) textField
                    inputView:(UIView *) inputView
                   controller:(UIViewController *) controller
                         done:(SEL) done
                       cancel:(SEL)cancel{
    if(textField && inputView){
        textField.inputView = inputView;
        UIToolbar * sexToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width , 44)];
        sexToolBar.barStyle = UIBarStyleBlackOpaque;
        NSMutableArray * items = [[NSMutableArray alloc] init];
        if(cancel){
            UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:controller action:cancel];
            [items addObject:cancelItem];
        }
        if(controller && [controller respondsToSelector:done]){
            UIBarButtonItem * doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:controller action:done];
            UIBarButtonItem * space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil];
            [items addObject:space];
            [items addObject:doneItem];
        }
        [sexToolBar setItems:items];
        textField.inputAccessoryView = sexToolBar;
    }
}

/*
 *  添加视图到视图
 */
+(void) addViewInView:(UIView *) view
               subview:(UIView *) subview
                   tag:(NSInteger) tag{
    if(view && subview){
        if(tag){
            //替换以前的tag控件
            [[view viewWithTag:tag] removeFromSuperview];
            subview.tag = tag;
        }
        [view addSubview:subview];
    }
}

@end