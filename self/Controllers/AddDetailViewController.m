//
//  AddDetailViewController.m
//  self
//
//  Created by roy on 16/3/4.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "AddDetailViewController.h"
#import "DomainFactory.h"
#import "DetailService.h"
#import "HomeViewController.h"
#import "AccountInfoManager.h"

#define Tag_Detail_Type 3001
#define Tag_Detail_Amount 3002
#define Tag_Detail_Happen_Time 3003
#define Tag_Detail_Memo 3004
@interface AddDetailViewController()<UIPickerViewDelegate,UIPickerViewDataSource>

CREATE_TYPE_PROPERTY_TO_VIEW(UITextField, type)
CREATE_TYPE_PROPERTY_TO_VIEW(UITextField, amount)
CREATE_TYPE_PROPERTY_TO_VIEW(UITextField, happenTime)
CREATE_TYPE_PROPERTY_TO_VIEW(UITextView, memo)

CREATE_TYPE_PROPERTY_TO_VIEW(NSDictionary, typeData)
CREATE_TYPE_PROPERTY_TO_VIEW(UIPickerView, typePicker)
CREATE_TYPE_PROPERTY_TO_VIEW(NSArray, data)

CREATE_TYPE_PROPERTY_TO_VIEW(UIDatePicker, datePicker)
CREATE_TYPE_PROPERTY_TO_VIEW(DetailService, detailService)

@end

@implementation AddDetailViewController

- (id) init{
    if(self=[super init]){
        super.navTitle = @"新增明细";
        super.showBack = YES;
    }
    return self;
}

- (void) viewDidLoad{
    [super viewDidLoad];
    
    self.detailService = [[DetailService alloc] init];
    CGFloat top = super.topSize;
    NSArray * fileds = @[Detail_Type,Detail_Amount,Detail_Happen_Time,Detail_Memo];
    
    CGFloat maxLabelWidth = [UIUtil textMaxWidth:fileds font:Default_Font];
    CGFloat viewWidth = maxLabelWidth+Default_View_Space+Default_TextFiled_Width;
    CGFloat viewX = (Main_Screen_Width-viewWidth)/2;
    CGFloat viewTop = top+Default_View_Space;
    CGFloat viewHeight = Main_Screen_Height - viewTop;
    CGRect viewRect = CGRectMake(viewX, viewTop , viewWidth, viewHeight);
    UIView * view = [[UIView alloc] initWithFrame:viewRect];

    CGFloat tagIndex = Tag_Detail_Type;
    //类型框坐标
    viewRect = CGRectMake(0, 0, maxLabelWidth, Default_Label_Height);
    for(int i=0;i<fileds.count;i++){
        NSString * str = fileds[i];
        [UIUtil addLabelTextFiledInView:view text:str rect:viewRect tag:[[NSNumber alloc] initWithInt:tagIndex]];
        tagIndex ++;
        viewRect.origin.y +=Default_Label_Height + Default_View_Space;
    }
    //收支类型
    self.type = [view viewWithTag:Tag_Detail_Type];
    self.type.text = Detail_Type_In;
    self.type.clearButtonMode = UITextFieldViewModeNever;
    self.typeData = @{Detail_Type_In:[NSNumber numberWithInt:In],Detail_Type_Out:[NSNumber numberWithInt:Out]};
    self.data = self.typeData.allKeys;
    //收支类型选择器
    self.typePicker = [[UIPickerView alloc] init];
    self.typePicker.showsSelectionIndicator = YES;
    self.typePicker.delegate = self;
    self.typePicker.dataSource = self;
    self.typePicker.frame = CGRectMake(0, 0, 0, 100);
    //self.sex.userInteractionEnabled = NO;
    [UIUtil addTextFildInputView:self.type inputView:self.typePicker controller:self done:@selector(typeDoneTouch:) cancel:nil];

    //金额
    self.amount = [view viewWithTag:Tag_Detail_Amount];
    self.amount.keyboardType = UIKeyboardTypeNumberPad;
    self.amount.clearButtonMode = UITextFieldViewModeNever;
    
    //发生时间
    self.happenTime = [view viewWithTag:Tag_Detail_Happen_Time];
    self.happenTime.clearButtonMode = UITextFieldViewModeNever;
    //发生时间选择器
    NSDate * now = [Util nowDate];
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.frame = CGRectMake(0, 0, 0, 100);
    self.datePicker.date = now;
    self.datePicker.maximumDate = now;
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [UIUtil addTextFildInputView:self.happenTime inputView:self.datePicker controller:self done:@selector(happenTimeDoneTouch:) cancel:nil];
    
    UIView * beforeMemo = [view viewWithTag:Tag_Detail_Memo];
    viewRect = beforeMemo.frame;
    [beforeMemo removeFromSuperview];
    viewRect.size.height*=3;
    self.memo = [[UITextView alloc] initWithFrame:viewRect];
    self.memo.layer.borderColor = [[UIColor colorWithRed:208.0/255 green:208.0/255 blue:208.0/255 alpha:1] CGColor];
    self.memo.layer.borderWidth = 0.5;
    self.memo.layer.cornerRadius = 8.0;
    [self.memo.layer setMasksToBounds:YES];
    [UIUtil addViewInView:view subview:self.memo tag:[NSNumber numberWithInt:Tag_Detail_Memo]];
    
    //提交按钮
    CGFloat btnWidth = viewWidth/2;
    viewRect.origin.y += viewRect.size.height+Default_View_Space;
    viewRect.size.width = btnWidth;
    viewRect.origin.x = btnWidth/2;
    viewRect.size.height = Default_Label_Height;
    [UIUtil addButtonInView:view title:Submit rect:viewRect sel:@selector(submitAdd) controller:self tag:nil];

    [super.view addSubview:view];
}

- (void) backHome{
    [[AccountInfoManager sharedInstance] total];
    [super clickBack];
}

- (void) submitAdd{
    NSString * typeString = [self.type.text stringByCutEmpty];
    if([typeString hasValue]){
        NSNumber * obj = [self.typeData objectForKey:typeString];
        EDetailType eType = [obj integerValue];
        NSString * amountString = [self.amount.text stringByCutEmpty];
        if([amountString hasValue]){
            NSNumber * amount = [Util toNumber:amountString];
            if(amount){
                NSString * happenTimeString = self.happenTime.text;
                if([happenTimeString hasValue]){
                    NSDate * date = [Util stringToDate:happenTimeString format:Default_Date_Time_Format];
                    if(date){
                        Detail * detail = [DomainFactory initDetail];
                        detail.detail_type = eType;
                        detail.amount = amount;
                        detail.happen_time = [NSNumber numberWithInt:[date timeIntervalSince1970]];
                        detail.memo = self.memo.text;
                        detail.user_id = [[AccountInfoManager sharedInstance] user].user_id;
                        if([self.detailService add:detail]){
                            [super showAlert:Alert_Info message:@"添加成功,请点击确定返回" controller:nil sel:@selector(backHome)];
                        }
                        else{
                            [super showAlert:Alert_Error message:@"注册失败,请重新检查参数" controller:nil];
                        }
                    }else{
                        [super showAlert:Alert_Warning message:@"日期格式错误" controller:nil];
                    }
                }else{
                    [super showAlert:Alert_Warning message:@"请选择发生时间" controller:nil];
                }
            }else{
                [super showAlert:Alert_Warning message:@"金额格式错误" controller:nil];
            }
        }else{
            [super showAlert:Alert_Warning message:@"请输入金额" controller:nil];
        }
    }else{
        [super showAlert:Alert_Warning message:@"请选择收支类型" controller:nil];
    }
}

- (void) typeDoneTouch:(UIBarButtonItem *) sender{
    self.type.text = [self.data objectAtIndex:[self.typePicker selectedRowInComponent:0]];
    [self.type resignFirstResponder];
}

- (void) happenTimeDoneTouch:(UIBarButtonItem *) sender{
    self.happenTime.text =[Util dateToString:[self.datePicker date] format:Default_Date_Time_Format];
    [self.happenTime resignFirstResponder];
}


#pragma mark sex picker
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.data count];
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.data objectAtIndex:row];
}


@end
