//
//  Chart.h
//  self
//
//  Created by roy on 16/5/26.
//  Copyright © 2016年 onions. All rights reserved.
//

#ifndef Chart_h
#define Chart_h

#import <Charts/Charts.h>

@interface Chart : NSObject

+ (PieChartView*) initPieChart;

+ (void) setPieCenterMessage:(PieChartView *) chartView
                         msg:(NSString *) msg;

+ (void) showPieData:(PieChartView *) chartView
               xVals:(NSArray*) xVals
               yVals:(NSArray*) yVals;

@end

#endif /* Chart_h */
