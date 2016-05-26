//
//  StatisticViewController.m
//  self
//
//  Created by roy on 16/5/26.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "StatisticViewController.h"
#import "Chart.h"

@interface StatisticViewController ()

CREATE_TYPE_PROPERTY_TO_VIEW(UITextField, year)
CREATE_TYPE_PROPERTY_TO_VIEW(UITextField, month)
CREATE_TYPE_PROPERTY_TO_VIEW(PieChartView, chartView)

@end

@implementation StatisticViewController

- (PieChartView *)chartView{
    if(!_chartView){
        _chartView = [Chart initPieChart];
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
    
    UITextField * month = [UIUtil addTextFiledInView:inputView rect:year.frame tag:0];
    month.left = year.right + Default_View_Space;
    month.placeholder = @"请选择月份";
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
    int count = 3;
    if(count==0){
        self.chartView.data = nil;
        return;
    }
    NSMutableArray * xVals = [[NSMutableArray alloc] init];
    NSMutableArray * yVals = [[NSMutableArray alloc] init];
    for(int i=0;i<count;i++){
        [xVals addObject:[NSString stringWithFormat:@"name%c",i+'A']];
        BarChartDataEntry * entry = [[BarChartDataEntry alloc] initWithValue:(i+1) xIndex:i];
        [yVals addObject:entry];
    }
    [Chart showPieData:self.chartView xVals:xVals yVals:yVals];
}

@end