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

///根据条件创建查询语句
- (NSString *) createQuery:(NSNumber *) userId start:(NSNumber *) startTime end:(NSNumber *) endTime type:(NSNumber *) type{
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
    return query;
}
///统计方法
- (void) totalAll:(NSString *) query rin:(float *) rin rout:(float *) rout{
    NSString * dtField = @"detail_type";
    NSString * amountField = @"amount";
    NSString * total = [NSString stringWithFormat:@"select detail_type as %@,sum(amount) as %@ %@ group by detail_type",dtField,amountField,query];
    NSArray<NSDictionary *> * list = [[super db] selectData:total];
    float totalIn = 0;
    float totalOut = 0;
    for(NSDictionary * dic in list){
        NSNumber * key = [Util toNumber:[dic objectForKey:dtField]];
        if(key){
            float amount = [Util toNumber:[dic objectForKey:amountField]].floatValue;
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
    *rin = totalIn;
    *rout = totalOut;
}

///图表统计数据
- (void) search:(NSNumber *) userId year:(int) year month:(int) month tin:(float *) tin tout:(float*) tout{
    NSMutableString * start = [[NSMutableString alloc] init];
    NSMutableString * end = [[NSMutableString alloc] init];
    if(year>0){
        if(month>0){
            [start appendFormat:@"%d-%2d-01 00:00:00",year,month];
            if(month==12){
                [end appendFormat:@"%d-01-01 00:00:00",(year+1)];
            }else{
                [end appendFormat:@"%d-%2d-01 00:00:00",year,(month+1)];
            }
        }else{
            [start appendFormat:@"%d-01-01 00:00:00",year];
            [end appendFormat:@"%d-01-01 00:00:00",(year+1)];
        }
    }
    NSNumber * startNum;
    NSNumber * endNum;
    if(start.length>0){
        NSDate * startDate = [Util stringToDate:start format:Default_Date_Time_Format];
        startNum = @([startDate timeIntervalSince1970]-1);
    }
    if(end.length>0){
        NSDate * endDate = [Util stringToDate:end format:Default_Date_Time_Format];
        endNum = @([endDate timeIntervalSince1970]);
    }
    [self totalAll:[self createQuery:userId start:startNum end:endNum type:nil] rin:tin rout:tout];
}

/*
 *  查询收支明细
 */
- (NSArray<Detail*> *) search:(NSNumber *) userId start:(NSNumber *) startTime end:(NSNumber *) endTime type:(NSNumber *) type page:(int) page size:(int) size count:(int *) totalCount title:(NSMutableString*) title{
    NSString * query = [self createQuery:userId start:startTime end:endTime type:type];
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
        float totalIn = 0;
        float totalOut = 0;
        [self totalAll:query rin:&totalIn rout:&totalOut];
        float totalAll = totalIn-totalOut;
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
///获取最小发生时间
- (NSString *) happenTimeMin:(NSNumber *) userId{
    NSString * sql = [NSString stringWithFormat:@"select min(happen_time) as happen_time from detail where user_id = %@",userId];
    NSArray<NSDictionary*> * result = [[super db] selectData:sql];
    if(result.count>0){
        return result[0].allValues[0];
    }
    return nil;
}

@end