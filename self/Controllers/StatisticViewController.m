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

@interface StatisticViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

CREATE_TYPE_PROPERTY_TO_VIEW(UITextField, year)
CREATE_TYPE_PROPERTY_TO_VIEW(UIPickerView, yearPicker)
CREATE_TYPE_PROPERTY_TO_VIEW(UITextField, month)
CREATE_TYPE_PROPERTY_TO_VIEW(UIPickerView, monthPicker)
CREATE_TYPE_PROPERTY_TO_VIEW(PieChartView, chartView)
CREATE_TYPE_PROPERTY_TO_VIEW(DetailService, detailService)
CREATE_TYPE_PROPERTY_TO_VIEW(NSMutableArray, years)
CREATE_TYPE_PROPERTY_TO_VIEW(NSMutableArray, months)
CREATE_TYPE_PROPERTY_TO_VIEW(User, user)

@end

@implementation StatisticViewController

- (User *)user{
    return [AccountInfoManager sharedInstance].user;
}

-(NSMutableArray *)years{
    if(!_years){
        _years = [[NSMutableArray alloc] init];
        NSDate * date = [Util timeToDate:[self user].create_time];
        NSDate * now = [NSDate date];
        for(int i=date.year;i<now.year+1;i++){
            [_years addObject:@(i).stringValue];
        }
    }
    return _years;
}

- (NSMutableArray *) months{
    if(!_months){
        _months = [[NSMutableArray alloc] init];
        for(int i=1;i<13;i++){
            [_months addObject:@(i).stringValue];
        }
    }
    return _months;
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
        super.navTitle = @"收支统计图";
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
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(left, top, topView.width-2*left, 0)];
    
    UIView * inputView = [[UIView alloc] initWithFrame:CGRectMake(left, top, view.width - 2*left, Default_Label_Height)];
    
    UITextField * year = [UIUtil addTextFiledInView:inputView rect:CGRectZero tag:0];
    year.width = (inputView.width - Default_View_Space)/2;
    year.height = inputView.height;
    year.placeholder = @"请选择年份";
    self.year = year;
    //年份选择器
    self.yearPicker = [[UIPickerView alloc] init];
    self.yearPicker.tag = TagStatisticYearPicker;
    self.yearPicker.showsSelectionIndicator = YES;
    self.yearPicker.delegate = self;
    self.yearPicker.dataSource = self;
    self.yearPicker.frame = CGRectMake(0, 0, 0, 100);
    [UIUtil addTextFildInputView:self.year inputView:self.yearPicker controller:self done:@selector(yearDoneTouch:) cancel:nil];
    
    UITextField * month = [UIUtil addTextFiledInView:inputView rect:year.frame tag:0];
    month.left = year.right + Default_View_Space;
    month.placeholder = @"请选择月份";
    self.month = month;
    //月份选择器
    self.monthPicker = [[UIPickerView alloc] init];
    self.monthPicker.showsSelectionIndicator = YES;
    self.monthPicker.delegate = self;
    self.monthPicker.dataSource = self;
    self.monthPicker.frame = CGRectMake(0, 0, 0, 100);
    [UIUtil addTextFildInputView:self.month inputView:self.monthPicker controller:self done:@selector(monthDoneTouch:) cancel:nil];
    
    [view addSubview:inputView];
    
    UIButton * button = [UIUtil addButtonInView:view title:Submit rect:CGRectZero sel:@selector(setChartData) controller:self tag:0];
    button.top = inputView.bottom + Default_View_Space;
    button.width = view.width/2;
    button.height = Default_Label_Height;
    button.centerX = button.width;
    
    view.height = button.bottom + Default_View_Space;
    
    view.layer.borderWidth = 1;
    view.layer.borderColor = [LINE_COLOR CGColor];
    view.layer.cornerRadius = 8;
    view.layer.masksToBounds = YES;
    
    [topView addSubview:view];
    topView.height = view.bottom+ Default_View_Space;
}

- (void) drawMain:(UIView*) mainView{
    [mainView addSubview:self.chartView];
    self.chartView.frame = mainView.frame;
    self.chartView.top = 0;
}

- (void) setChartData{
    CGFloat totalIn = 0;
    CGFloat totalOut = 0;
    [self.detailService search:self.user.user_id year:self.year.text.intValue month:self.month.text.intValue tin:&totalIn tout:&totalOut];
    if(totalOut==0 && totalIn==0){
        self.chartView.data = nil;
        return;
    }
    
    NSMutableArray * xVals = [[NSMutableArray alloc] init];
    [xVals addObject:[NSString stringWithFormat:@"收入:%@",[[NSString stringWithFormat:@"%f",totalIn] thousandNumber]]];
    [xVals addObject:[NSString stringWithFormat:@"支出:%@",[[NSString stringWithFormat:@"%f",totalOut] thousandNumber]]];
    
    NSMutableArray * yVals = [[NSMutableArray alloc] init];
    [yVals addObject:[[BarChartDataEntry alloc] initWithValue:totalIn xIndex:0]];
    [yVals addObject:[[BarChartDataEntry alloc] initWithValue:totalOut xIndex:1]];
    
    [Chart showPieData:self.chartView xVals:xVals yVals:yVals];
}

/*
 *  年份填充
 */
- (void) yearDoneTouch:(UIBarButtonItem *) sender{
    self.year.text = [self.years objectAtIndex:[self.yearPicker selectedRowInComponent:0]];
    [self.year resignFirstResponder];
}
/*
 *  月份填充
 */
- (void) monthDoneTouch:(UIBarButtonItem *) sender{
    self.month.text = [self.months objectAtIndex:[self.monthPicker selectedRowInComponent:0]];
    [self.month resignFirstResponder];
}

#pragma mark sex picker
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerView.tag == TagStatisticYearPicker){
        return self.years.count;
    }else{
        return self.months.count;
    }
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(pickerView.tag == TagStatisticYearPicker){
        return self.years[row];
    }else{
        return self.months[row];
    }
}

@end