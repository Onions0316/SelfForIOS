//
//  Chart.m
//  self
//
//  Created by roy on 16/5/26.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "Chart.h"

@implementation Chart

+ (PieChartView*) initPieChart{
    PieChartView *chartView = [[PieChartView alloc] init];
    //设置使用用户自定义样式
    chartView.usePercentValuesEnabled = YES;
    chartView.descriptionText = @"";
    chartView.noDataTextDescription = @"no data";
    chartView.noDataText = @"";
    //各方向间距
    [chartView setExtraOffsetsWithLeft:20.f top:50.f right:20.f bottom:50.f];
    //_chartView.holeRadiusPercent = 0.58;
    //是否显示中心部分
    chartView.drawHoleEnabled = YES;
    //中间孔占比
    chartView.holeRadiusPercent = 0.58;
    //中间透明圆半径
    chartView.transparentCircleRadiusPercent = 0.61;
    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"IOS Pie Charts"];
    chartView.centerAttributedText = centerText;
    //旋转
    chartView.rotationAngle = 0.0;
    chartView.rotationEnabled = YES;
    
    chartView.legend.enabled = NO;
    return chartView;
}

+ (void) showPieData:(PieChartView *) chartView
               xVals:(NSArray*) xVals
               yVals:(NSArray*) yVals{
    PieChartDataSet * dataSet = [[PieChartDataSet alloc] initWithYVals:yVals label:@"Results"];
    //每个块之间间距
    dataSet.sliceSpace = 2;
    //块的颜色数组，当块很多时颜色会重用
    dataSet.colors = @[[UIColor redColor],[UIColor blueColor],[UIColor greenColor]];
    //指示线点在内容块上的位置1为外边上  0为内边
    dataSet.valueLinePart1OffsetPercentage = 1;
    //指示线第一条线长度比例
    dataSet.valueLinePart1Length = 0.4;
    //指示线第二条线长度比例
    dataSet.valueLinePart2Length = 0.4;
    //指示线位置
    dataSet.yValuePosition = PieChartValuePositionOutsideSlice;
    
    PieChartData * data = [[PieChartData alloc] initWithXVals:xVals dataSet:dataSet];
    
    //样式
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterPercentStyle;
    //小数点
    formatter.maximumFractionDigits = 1;
    //基数,总共为1
    formatter.multiplier = @1;
    formatter.percentSymbol = @"%";
    [data setValueFormatter:formatter];
    
    [data setValueFont:[UIFont systemFontOfSize:11]];
    [data setValueTextColor:[UIColor grayColor]];
    
    chartView.data = data;
}

@end
