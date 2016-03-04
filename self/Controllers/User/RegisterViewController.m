//
//  RegisterViewController.m
//  self
//
//  Created by roy on 16/3/2.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "RegisterViewController.h"
#import "DomainFactory.h"
#import "UserService.h"
#import "LoginViewController.h"

#define Register_Name_Tag 1001
#define Register_Password_Tag 1002
#define Register_Password_Comfirm_Tag 1003
#define Register_Real_Name_Tag 1004
#define Register_Sex_Tag 1005
#define Register_Birthday_Tag 1006

@interface RegisterViewController()<UIPickerViewDelegate,UIPickerViewDataSource>

CREATE_TYPE_PROPERTY_TO_VIEW(UITextField, name)
CREATE_TYPE_PROPERTY_TO_VIEW(UITextField, password)
CREATE_TYPE_PROPERTY_TO_VIEW(UITextField, passwordConfirm)
CREATE_TYPE_PROPERTY_TO_VIEW(UITextField, realName)
CREATE_TYPE_PROPERTY_TO_VIEW(UITextField, sex)
CREATE_TYPE_PROPERTY_TO_VIEW(UITextField, birthday)
CREATE_TYPE_PROPERTY_TO_VIEW(UIDatePicker, birthdayDatePicker)

CREATE_TYPE_PROPERTY_TO_VIEW(UIPickerView, sexPicker)
CREATE_TYPE_PROPERTY_TO_VIEW(NSDictionary, sexData)
CREATE_TYPE_PROPERTY_TO_VIEW(NSArray, data)

CREATE_TYPE_PROPERTY_TO_VIEW(UserService, userService)

@end

@implementation RegisterViewController


- (id) init{
    if(self=[super init]){
        super.navTitle = Register;
        super.showBack = YES;
        super.checkLogin = NO;
    }
    return self;
}

- (void) viewDidLoad{
    [super viewDidLoad];
    
    self.userService = [[UserService alloc] init];
    
    CGFloat top = super.topSize;
    NSArray * fileds = @[User_Name,User_Password,User_Password_Confirm,User_Real_Name,User_Sex,User_Birthday];
    CGFloat maxLabelWidth = [UIUtil textMaxWidth:fileds font:Default_Font];
    CGFloat viewWidth = maxLabelWidth+Default_View_Space+Default_TextFiled_Width;
    CGFloat viewX = (Main_Screen_Width-viewWidth)/2;
    CGFloat viewTop = top+Default_View_Space;
    CGFloat viewHeight = Main_Screen_Height - viewTop;
    CGRect viewRect = CGRectMake(viewX, viewTop , viewWidth, viewHeight);
    UIView * view = [[UIView alloc] initWithFrame:viewRect];
    //用户名输入框坐标
    viewRect = CGRectMake(0, 0, maxLabelWidth, Default_Label_Height);
    CGFloat tagStart = Register_Name_Tag;
    for(NSString * str in fileds){
        [UIUtil addLabelTextFiledInView:view text:str rect:viewRect tag:[[NSNumber alloc] initWithInt:tagStart]];
        tagStart ++;
        viewRect.origin.y +=Default_Label_Height + Default_View_Space;
    }
    //用户名
    self.name=[view viewWithTag:Register_Name_Tag];
    self.name.placeholder = User_Name_Memo;
    [self.name addTarget:self action:@selector(textFiledDidEdit:) forControlEvents:UIControlEventEditingDidEnd];
    //密码
    self.password = [view viewWithTag:Register_Password_Tag];
    self.password.placeholder = User_Password_Memo;
    self.password.secureTextEntry = YES;
    //确认密码
    self.passwordConfirm = [view viewWithTag:Register_Password_Comfirm_Tag];
    self.passwordConfirm.placeholder = User_Password_Memo;
    self.passwordConfirm.secureTextEntry = YES;
    //真实姓名
    self.realName = [view viewWithTag:Register_Real_Name_Tag];
    //性别
    self.sex = [view viewWithTag:Register_Sex_Tag];
    self.sex.text = User_Sex_Man;
    self.sexData = @{User_Sex_Man:[NSNumber numberWithInt:Man],User_Sex_Woman:[NSNumber numberWithInt:Woman]};
    self.data = self.sexData.keyEnumerator.allObjects;
    //性别选择器
    self.sexPicker = [[UIPickerView alloc] init];
    self.sexPicker.showsSelectionIndicator = YES;
    self.sexPicker.delegate = self;
    self.sexPicker.dataSource = self;
    self.sexPicker.frame = CGRectMake(0, 0, 0, 100);
    //self.sex.userInteractionEnabled = NO;
    [UIUtil addTextFildInputView:self.sex inputView:self.sexPicker controller:self done:@selector(sexDoneTouch:) cancel:nil];
    //[view addSubview:self.sexPicker];
    //生日
    self.birthday = [view viewWithTag:Register_Birthday_Tag];
    NSDate * now = [Util nowDate];
    self.birthdayDatePicker = [[UIDatePicker alloc] init];
    self.birthdayDatePicker.frame = CGRectMake(0, 0, 0, 100);
    self.birthdayDatePicker.date = now;
    self.birthdayDatePicker.maximumDate = now;
    self.birthdayDatePicker.datePickerMode = UIDatePickerModeDate;
    [UIUtil addTextFildInputView:self.birthday inputView:self.birthdayDatePicker controller:self done:@selector(birthdayDoneTouch:) cancel:nil];
    //提交按钮
    CGFloat btnWidth = viewWidth/2;
    viewRect.size.width = btnWidth;
    viewRect.origin.x = btnWidth/2;
    [UIUtil addButtonInView:view title:Register rect:viewRect sel:@selector(submitRegister) controller:self tag:nil];
    
    [self.view addSubview:view];
}

/*
 *  去空格
 */
- (void) textFiledDidEdit:(UITextField *) sender{
    sender.text = [[sender.text stringByCutEmpty] lowercaseString];
}

- (void) backLogin{
    [super goControllerByClass:[LoginViewController class]];
}

- (void) submitRegister{
    NSString * nameString = [self.name.text stringByCutEmpty];
    if([nameString hasValue]){
        if(![self.userService checkName:nameString]){
            NSString * passwrodString = [self.password.text stringByCutEmpty];
            if([passwrodString hasValue]){
                NSString * passwrodConfirmString = [self.passwordConfirm.text stringByCutEmpty];
                if([passwrodString hasValue]){
                    if([passwrodString isEqualToString:passwrodConfirmString]){
                        User * user = [DomainFactory initUser];
                        user.name = nameString;
                        user.password = passwrodString;
                        user.real_name = self.realName.text;
                        NSString * sexString = [self.sex.text stringByCutEmpty];
                        if([sexString hasValue]){
                            NSNumber * obj = [self.sexData objectForKey:sexString];
                            user.sex = [obj integerValue];
                        }
                        NSString * birthdayString = self.birthday.text;
                        if([birthdayString hasValue]){
                            NSDate * date = [Util stringToDate:birthdayString format:Default_Date_Format];
                            if(date){
                                user.birthday = [NSNumber numberWithInt:[date timeIntervalSince1970]];
                            }
                        }
                        if([self.userService add:user]){
                            [super showAlert:Alert_Info message:@"注册成功,请点击确定返回登录" controller:nil sel:@selector(backLogin)];
                        }else{
                            [super showAlert:Alert_Error message:@"注册失败,请重新检查参数" controller:nil];
                        }
                    }else{
                        [super showAlert:Alert_Warning message:@"2次密码不同,请重新输入" controller:nil];
                    }
                }else{
                    [super showAlert:Alert_Warning message:@"请输入确认密码" controller:nil];
                }
            }else{
                [super showAlert:Alert_Warning message:@"请输入密码" controller:nil];
            }
        }else{
            [super showAlert:Alert_Warning message:@"用户名被占用,请换一个用户名" controller:nil];
        }
    }else{
        [super showAlert:Alert_Warning message:@"请输入用户名" controller:nil];
    }
}

- (void) sexDoneTouch:(UIBarButtonItem *) sender{
    self.sex.text = [self.data objectAtIndex:[self.sexPicker selectedRowInComponent:0]];
    [self.sex resignFirstResponder];
}

- (void) birthdayDoneTouch:(UIBarButtonItem *) sender{
    self.birthday.text =[Util dateToString:[self.birthdayDatePicker date] format:Default_Date_Format];
    [self.birthday resignFirstResponder];
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