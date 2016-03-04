//
//  BaseService.h
//  self
//
//  Created by roy on 16/3/1.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "DomainFactory.h"
#import <objc/runtime.h>
#import "Util.h"
#import "Single.h"

#ifndef BaseService_h
#define BaseService_h
/*
 *  实体新增语句(接口方法)
 */
#define DOMAIN_TO_INSERT_INTERFACE(__TYPE__)\
+ (NSString *) insert##__TYPE__##SQL:(__TYPE__ *) obj;
/*
 *  实体新增语句
 */
#define DOMAIN_TO_INSERT(__TYPE__)\
+ (NSString *) insert##__TYPE__##SQL:(__TYPE__ *) obj{\
    NSString * result = nil;\
    if(obj){\
        unsigned int count;\
        NSMutableString * keys=[[NSMutableString alloc] init];\
        NSMutableString * values=[[NSMutableString alloc] init];\
        Class tClass = [__TYPE__ class];\
        while(![NSObject isSubclassOfClass:tClass]){\
            objc_property_t * properties = class_copyPropertyList(tClass,&count);\
            for(int i=0;i<count;i++){\
                NSString * key = [NSString stringWithUTF8String:property_getName(properties[i])];\
                id value = [obj valueForKey:key];\
                if(value){\
                    [keys appendFormat:@"%@,",key];\
                    [values appendFormat:@"'%@',",value];\
                }\
            }\
            tClass = [tClass superclass];\
        }\
        if(keys.length>0 && values.length>0){\
            result = [NSString stringWithFormat:@"insert into %@ (%@) values (%@);",[__TYPE__ class],[keys substringToIndex:keys.length-1],[values substringToIndex:values.length-1]];\
        }\
    }\
    return result;\
}

@interface BaseService : NSObject

@property (nonatomic,strong) SQLiteOperation * db;

- (NSString *) insertSQL:(id) obj;
- (NSString *) updateSQL:(id) obj;
- (NSString *) selectSQL:(Class) objClass params:(NSDictionary *) dic;
- (NSArray *) select:(Class) objClass sql:(NSString *) sql;
- (NSString *) deleteSQL:(Class) class objId:(NSNumber *) objId;
- (NSString *) deleteSQL:(Class) class foreign:(Class) foreignClass objId:(NSNumber *) objId;
@end

#endif /* BaseService_h */
