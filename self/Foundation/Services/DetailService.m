//
//  DetailService.m
//  self
//
//  Created by roy on 16/3/1.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "DetailService.h"

/*
 *  明细方法
 */
@implementation DetailService


/*
 *  新增方法
 */
- (BOOL) add:(Detail *) detail{
    NSString * sql = [super insertSQL:detail];
    return [super.db eval:sql params:nil];
}


@end