//
//  StatisticViewController.m
//  self
//
//  Created by roy on 16/5/26.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "StatisticViewController.h"
#import "Chart.h"
#import "DetailService.h"
#import "AccountInfoManager.h"

#define TagStatisticYearPicker 1000
#define YearComponent 0
#define MonthComponent 1

@interface StatisticViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

CREATE_TYPE_PROPERTY_TO_VIEW(UITextField, date)
CREATE_TYPE_PROPERTY_TO_VIEW(UIPickerView, datePicker)
CREATE_TYPE_PROPERTY_TO_VIEW(NSMutableArray, data)
CREATE_TYPE_PROPERTY_TO_VIEW(PieChartView, chartView)
CREATE_TYPE_PROPERTY_TO_VIEW(DetailService, detailService)
CREATE_TYPE_PROPERTY_TO_VIEW(User, user)

@end

@implementation StatisticViewController

- (User *)user{
    return [AccountInfoManager sharedInstance].user;
}

- (NSMutableArray *)data{
    if(!_data){
        _data = [[NSMutableArray alloc] init];
        
        NSMutableArray * years = [[NSMutableArray alloc] init];
        [years addObject:Search_Type_All];
        NSString * dateString = [self.detailService happenTimeMin:[self user].user_id];
        NSNumber * dateNumber = [self user].create_time;
        if(dateString.length>0){
            dateNumber = [Util toNumber:dateString];
        }
        NSDate * date = [Util timeToDate:dateNumber];
        NSDate * now = [NSDate date];
        for(NSInteger i=now.year;i>date.year-1;i--){
            [years addObject:@(i).stringValue];
        }
        
        NSMutableArray * months = [[NSMutableArray alloc] init];
        [months addObject:Search_Type_All];
        for(int i=1;i<13;i++){
            [months addObject:@(i).stringValue];
        }
        
        [_data addObject:years];
        [_data addObject:months];
    }
    return _data;
}

- (PieChartView *)chartView{
    if(!_chartView){
        _chartView = [Chart initPieChart];
        //_chartView.drawHoleEnabled = NO;
        _chartView.noDataTextDescription = @"暂无数据";
    }
    return _chartView;
}
- (id) init{
    if(self=[super init]){
        super.navTitle = Statistic;
        super.showBack = YES;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.detailService = [[DetailService alloc] init];
}

- (void)drawContent{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, self.topSize, self.view.width, 0)];
    view.height = self.view.height - view.top;
    
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.width, 0)];
    [self drawTop:topView];
    
    UIView * mainView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.bottom, view.width, 0)];
    mainView.height = view.height - mainView.top;
    [self drawMain:mainView];
    
    [view addSubview:topView];
    [view addSubview:mainView];
    [self.view addSubview:view];
}

- (void) drawTop:(UIView*) topView{
    CGFloat left = 15;
    CGFloat top = Default_View_Space;
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(left, top, topView.width-2*left, 2*Default_Label_Height+3*Default_View_Space)];
    
    UIImage * leftImage = [UIImage imageNamed:@"left"];
    CGFloat newHegiht = view.height/2;
    CGFloat newWidth = leftImage.size.width*newHegiht/leftImage.size.height;
    CGRect rect = CGRectMake(Default_View_Space, Default_View_Space, newWidth, newHegiht);
    UIButton * leftButton = [UIUtil addButtonInView:view image:leftImage rect:rect sel:@selector(leftTap) controller:self tag:0];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    leftButton.centerY = view.height/2;
    
    UIButton * rightButton =[UIUtil addButtonInView:view image:[UIImage imageNamed:@"right"] rect:leftButton.frame sel:@selector(rightTap) controller:self tag:0];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    rightButton.right = view.width - Default_View_Space;
    
    left = leftButton.left + left + Default_View_Space;
    
    UIView * inputView = [[UIView alloc] initWithFrame:CGRectMake(left, top, view.width - 2*left, Default_Label_Height)];
    
    UITextField * date = [UIUtil addTextFiledInView:inputView rect:CGRectZero tag:0];
    date.width = inputView.width;
    date.height = inputView.height;
    date.placeholder = Statistic_Time_Memo;
    date.textAlignment = NSTextAlignmentCenter;
    self.date = date;
    //初始化时间选择器
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(initDatePicker:) userInfo:nil repeats:NO];
    
    [view addSubview:inputView];
    
    UIButton * button = [UIUtil addButtonInView:view title:Submit rect:CGRectZero sel:@selector(setChartData) controller:self tag:0];
    button.top = inputView.bottom + Default_View_Space;
    button.width = view.width/2;
    button.height = Default_Label_Height;
    button.centerX = button.width;
    
    view.layer.borderWidth = 1;
    view.layer.borderColor = [LINE_COLOR CGColor];
    view.layer.cornerRadius = 8;
    view.layer.masksToBounds = YES;
    
    [topView addSubview:view];
    topView.height = view.bottom+ Default_View_Space;
}

- (void)initDatePicker:(NSTimer *) timer{
    //年份选择器
    self.datePicker = [[UIPickerView alloc] init];
    self.datePicker.tag = TagStatisticYearPicker;
    self.datePicker.showsSelectionIndicator = YES;
    self.datePicker.delegate = self;
    self.datePicker.dataSource = self;
    self.datePicker.frame = CGRectMake(0, 0, 0, 100);
    [UIUtil addTextFildInputView:self.date inputView:self.datePicker controller:self done:@selector(dateDoneTouch:) cancel:nil];
    
    [timer invalidate];
}

- (void) drawMain:(UIView*) mainView{
    [mainView addSubview:self.chartView];
    self.chartView.frame = mainView.frame;
    self.chartView.top = 0;
}

- (void) setChartData{
    CGFloat totalIn = 0;
    CGFloat totalOut = 0;
    [self.detailService search:self.user.user_id year:[self year].intValue month:[self month].intValue tin:&totalIn tout:&totalOut];
    if(totalOut==0 && totalIn==0){
        self.chartView.data = nil;
        return;
    }
    
    NSMutableArray * xVals = [[NSMutableArray alloc] init];
    [xVals addObject:[NSString stringWithFormat:@"收入:%@",[[NSString stringWithFormat:@"%f",totalIn] thousandNumber]]];
    [xVals addObject:[NSString stringWithFormat:@"支出:%@",[[NSString stringWithFormat:@"%f",totalOut] thousandNumber]]];
    
    CGFloat totalAll = totalIn- totalOut;
    NSString * totalAllStr = [[NSString stringWithFormat:@"%f",totalAll] thousandNumber];
    [Chart setPieCenterMessage:self.chartView msg:totalAllStr color:totalAll>0?[UIColor blueColor]:[UIColor redColor]];
    
    NSMutableArray * yVals = [[NSMutableArray alloc] init];
    [yVals addObject:[[BarChartDataEntry alloc] initWithValue:totalIn xIndex:0]];
    [yVals addObject:[[BarChartDataEntry alloc] initWithValue:totalOut xIndex:1]];
    
    [Chart showPieData:self.chartView xVals:xVals yVals:yVals];
    
    [self.chartView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
}

- (NSString *) dateForIndex:(NSInteger ) index{
    NSArray * arr = self.data[index];
    return arr[[self.datePicker selectedRowInComponent:index]];
}

- (NSString*) year{
    return [self dateForIndex:YearComponent];
}

- (NSString*) month{
    return [self dateForIndex:MonthComponent];
}

/*
 *  日期填充
 */
- (void) dateDoneTouch:(UIBarButtonItem *) sender{
    NSMutableString * text = [[NSMutableString alloc] init];
    [text appendString:[self year]];
    if([self year].intValue>0){
        [text appendString:@"年"];
    }
    if([self month].intValue>0){
        [text appendFormat:@"%@月",[self month]];
    }
    self.date.text = text;
    [self.date resignFirstResponder];
}

- (void) leftTap{
    [self tapImage:-1];
}

- (void) rightTap{
    [self tapImage:1];
}

- (void) tapImage:(NSInteger )dc{
    int year = [self year].intValue;
    if(year>0){
        int month = [self month].intValue;
        if(month>0){
            month += dc;
            if(month<=0){
                month = 12;
                year --;
            }
            if(month>12){
                month = 1;
                year++;
            }
        }else{
            year+=dc;
        }
        NSArray * arr = self.data[YearComponent];
        NSInteger row = [arr indexOfObject:[NSString stringWithFormat:@"%d",year]];
        if(row!=NSNotFound){
            [self.datePicker selectRow:row inComponent:YearComponent animated:YES];
            if(month>0){
                NSArray * months = self.data[MonthComponent];
                row = [months indexOfObject:[NSString stringWithFormat:@"%d",month]];
                if(row!=NSNotFound){
                    [self.datePicker selectRow:row inComponent:MonthComponent animated:YES];
                }
            }
            [self dateDoneTouch:nil];
            [self setChartData];
        }
    }
}

#pragma mark sex picker
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.data.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSArray * array = self.data[component];
    return array.count;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.data[component][row];
}

@end