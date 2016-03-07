//
//  BaseService.m
//  self
//
//  Created by roy on 16/3/1.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "BaseService.h"

@implementation BaseService

- (id) init{
    if(self=[super init]){
        self.db = [[Single sharedInstance] db];
    }
    return self;
}
/*
 *  生成新增语句
 */
- (NSString *) insertSQL:(id) obj{
    NSString * result = [[NSString alloc] init];
    if(obj){
        unsigned int count;
        NSMutableString * keys=[[NSMutableString alloc] init];
        NSMutableString * values=[[NSMutableString alloc] init];
        Class tClass = [obj class];
        while(![NSObject isSubclassOfClass:tClass]){
            objc_property_t * properties = class_copyPropertyList(tClass,&count);
            for(int i=0;i<count;i++){
                NSString * key = [NSString stringWithUTF8String:property_getName(properties[i])];
                if(key){
                    id value = [obj valueForKey:key];
                    if(value){
                        [keys appendFormat:@"%@,",key];
                        [values appendFormat:@"'%@',",value];
                    }
                }
            }
            tClass = [tClass superclass];
        }
        if(keys.length>0 && values.length>0){
            result = [NSString stringWithFormat:@"insert into %@ (%@) values (%@);",[obj class],[keys substringToIndex:keys.length-1],[values substringToIndex:values.length-1]];
        }
    }
    return result;
}

/*
 *  生成更新语句
 */
- (NSString *) updateSQL:(id) obj{
    NSString * result = [[NSString alloc] init];
    if(obj){
        unsigned int count;
        NSMutableString * sets=[[NSMutableString alloc] init];
        Class tClass = [obj class];
        NSString * className =[NSString stringWithFormat:@"%@",[obj class]];
        NSString * classId = [NSString stringWithFormat:@"%@_id",[className lowercaseString]];
        id idValue;
        while(![NSObject isSubclassOfClass:tClass]){
            objc_property_t * properties = class_copyPropertyList(tClass,&count);
            for(int i=0;i<count;i++){
                NSString * key = [NSString stringWithUTF8String:property_getName(properties[i])];
                if(key){
                    id value = [obj valueForKey:key];
                    if(value){
                        if([key isEqualToString:classId]){
                            idValue = value;
                        }else{
                            [sets appendFormat:@"%@='%@',",key,value];
                        }
                    }
                }
            }
            tClass = [tClass superclass];
        }
        if(idValue && sets.length>0){
            result = [NSString stringWithFormat:@"update %@ set %@ where %@=%@;",[obj class],[sets substringToIndex:sets.length-1],classId,idValue];
        }
    }
    return result;
}

/*
 *  生成查询语句
 */
- (NSString *) selectSQL:(Class) objClass params:(NSDictionary *) dic{
    NSMutableString * result = [[NSMutableString alloc] init];
    if(objClass){
        [result appendFormat:@"select * from %@",objClass];
        if(dic){
            BOOL isFirst = YES;
            for(NSString * key in dic.keyEnumerator){
                id value = [dic objectForKey:key];
                if(value && ![[NSNull null] isEqual:value]){
                    if(isFirst){
                        isFirst = NO;
                        [result appendString:@" where"];
                    }
                    else{
                        [result appendString:@" and"];
                    }
                    [result appendFormat:@" %@='%@'",key,value];
                }
            }
        }
    }
    return result;
}

/*
 *  通过id删除
 */
- (NSString *) deleteSQL:(Class) class objId:(NSNumber *) objId{
    NSMutableString * result = [[NSMutableString alloc] init];
    if(objId){
        NSString * className = [NSString stringWithFormat:@"%@",class];
        [result appendFormat:@"delete from %@ where %@_id = '%@'",className,className,objId];
    }
    return result;
}

/*
 *  通过外键id删除
 */
- (NSString *) deleteSQL:(Class) class foreign:(Class) foreignClass objId:(NSNumber *) objId{
    NSMutableString * result = [[NSMutableString alloc] init];
    if(objId){
        [result appendFormat:@"delete from %@ where %@_id = '%@'",class,foreignClass,objId];
    }
    return result;
}


/*
 *  执行查询语句
 */
- (NSArray *) select:(Class) objClass sql:(NSString *) sql{
    NSMutableArray * result = [[NSMutableArray alloc] init];
    NSArray * list = [[self db] selectData:sql];
    if(list.count>0){
        for(id objDic in list){
            if([objDic isKindOfClass:[NSDictionary class]]){
                [result addObject:[DomainFactory toDomain:objClass dic:(NSDictionary *)objDic]];
            }
        }
    }
    return result;
}

@end
