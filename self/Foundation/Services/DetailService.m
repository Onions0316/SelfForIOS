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
 *  查询单条数据
 */
- (Detail *) find:(NSNumber *) detailId{
    NSString * sql =[super selectSQL:[Detail class] params:@{@"detail_id":detailId}];
    NSArray* list = [super select:[Detail class] sql:sql];
    if(list && list.count==1){
        return (Detail *)list[0];
    }
    return nil;
}

/*
 *  新增方法
 */
- (BOOL) add:(Detail *) detail{
    NSString * sql = [super insertSQL:detail];
    return [super.db eval:sql params:nil];
}

/*
 *  查询收支明细
 */
- (NSArray<Detail*> *) search:(NSNumber *) userId start:(NSNumber *) startTime end:(NSNumber *) endTime type:(NSNumber *) type page:(int) page size:(int) size count:(int *) totalCount title:(NSMutableString*) title{
    NSMutableString * query = [NSMutableString stringWithFormat:@"from detail where user_id = %@",userId];
    NSMutableString * where = [[NSMutableString alloc] init];
    if(startTime){
        [where appendFormat:@" and happen_time >%@",startTime];
    }
    if(endTime){
        [where appendFormat:@" and happen_time <%@",endTime];
    }
    if(type){
        int typeInt = type.intValue;
        if(typeInt!=0){
            [where appendFormat:@" and detail_type=%d",typeInt];
        }
    }
    [query appendString:where];
    NSString * countField = @"count";
    NSString * countQuery = [NSString stringWithFormat:@"select count(*) as %@ %@",countField,query];
    //NSLog(@"%@",countQuery);
    int count = 0;
    NSArray * list = [[super db] selectData:countQuery];
    if(list && list.count==1){
        id l = list[0];
        if([l isKindOfClass:[NSDictionary class]]){
            count = [Util toNumber:[((NSDictionary *)l) objectForKey:countField]].intValue;
        }
    }
    *totalCount = count;
    if(page==0){
        NSString * dtField = @"detail_type";
        NSString * amountField = @"amount";
        NSString * total = [NSString stringWithFormat:@"select detail_type as %@,sum(amount) as %@ %@ group by detail_type",dtField,amountField,query];
        NSArray<NSDictionary *> * list = [[super db] selectData:total];
        NSNumber * totalIn = @0;
        NSNumber * totalOut = @0;
        for(NSDictionary * dic in list){
            NSNumber * key = [Util toNumber:[dic objectForKey:dtField]];
            if(key){
                NSNumber * amount = [Util toNumber:[dic objectForKey:amountField]];
                if(amount){
                    int keyInt = key.intValue;
                    if(keyInt>0){
                        totalIn = amount;
                    }
                    else if(keyInt<0){
                        totalOut = amount;
                    }
                }
            }
        }
        NSNumber * totalAll = [NSNumber numberWithFloat:totalIn.floatValue-totalOut.floatValue];
        [title appendFormat:@"总数:%d 合计:%@-%@=%@" ,count,[Util numberToString:totalIn],[Util numberToString:totalOut],[Util numberToString:totalAll]];
    }
    if(count>0){
        int start = page*size;
        if(start<=count){
            NSString * happenTime = @"happen_time";
            NSString * amount = @"amount";
            NSString * selectQuery = [NSString stringWithFormat:@"select happen_time as %@,detail_type*amount as %@,detail_id as detail_id %@ order by happen_time desc limit %d,%d",happenTime,amount,query,start,size];
            //NSLog(@"%@",selectQuery);
            NSArray<Detail*>* result = [super select:[Detail class] sql:selectQuery];
            return result;
        }
    }
    return nil;
}

/*
 *  统计数据条数
 */
- (NSNumber *) count:(NSNumber *) userId{
    if(userId){
        NSString * countField = @"countField";
        NSString * sql = [NSString stringWithFormat:@"select count(*) as %@ from detail where user_id = %@",countField,userId];
        NSArray<NSDictionary *> * list = [[super db] selectData:sql];
        if(list && list.count==1){
            NSDictionary * obj = list[0];
            return [Util toNumber: [obj objectForKey:countField]];
        }
    }
    return @0;
}

/*
 *  通过id删除数据
 */
- (BOOL) removeByIds:(NSArray *) ids{
    if(ids&&ids.count>0){
        NSString * sql =[NSString stringWithFormat:@"delete from detail where detail_id in (%@)",[ids componentsJoinedByString:@","]];
        //NSLog(@"%@",sql);
        return [[super db] eval:sql params:nil];
    }
    return YES;
}

/*
 *  通过id合并数据
 */
- (BOOL) mergeByIds:(NSArray *) ids{
    if(ids&&ids.count>0){
        NSString * sql =[NSString stringWithFormat:@"select detail_type,sum(amount) as amount,max(happen_time) as happen_time,min(happen_time) as create_time,max(user_id) as user_id from detail where detail_id in (%@) group by detail_type",[ids componentsJoinedByString:@","]];
        //NSLog(@"%@",sql);
        NSArray<Detail*>* result = [super select:[Detail class] sql:sql];
        if(result.count>0){
            [self removeByIds:ids];
            for(Detail * d in result){
                d.memo = [NSString stringWithFormat:@"%@ ~ %@数据合并",[Util dateToString:[Util timeToDate:d.create_time] format:Default_Date_Time_Format],[Util dateToString:[Util timeToDate:d.happen_time] format:Default_Date_Time_Format]];
                d.create_time = [Util nowTime];
                [self add:d];
            }
        }
    }
    return YES;
}

@end