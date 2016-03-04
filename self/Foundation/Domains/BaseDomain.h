//
//  BaseDomain.h
//  self
//
//  Created by roy on 16/2/29.
//  Copyright © 2016年 onions. All rights reserved.
//

#ifndef BaseDomain_h
#define BaseDomain_h

#import <Foundation/Foundation.h>
#import "Util.h"
#import <objc/runtime.h>
/*
 *  创建类型宏
 */
#define CREATE_TYPE_PROPERTY(__TYPE__,__NAME__)\
@property (nonatomic,copy) __TYPE__ * __NAME__;

#define BASE_DOMAIN_INTERFACE()\
+ (id) toDomain:(Class) objClass dic:(NSDictionary *) dic;\


#define BASE_DOMAIN()\
+ (id) toDomain:(Class) objClass dic:(NSDictionary *) dic{\
    id result;\
    if(dic && objClass){\
        result = [[objClass alloc] init];\
        for(NSString * str in dic.keyEnumerator){\
            id value = [dic objectForKey:str];\
            if(value && ![[NSNull null] isEqual:value]){\
                NSString * selectorName = [NSString stringWithFormat:@"set%@%@:",[[str substringToIndex:1] uppercaseString],[str substringFromIndex:1]];\
                if([result respondsToSelector:NSSelectorFromString(selectorName)]){\
                    [result setValue:value forKeyPath:str];\
                }\
            }\
        }\
    }\
    return result;\
}\

#define SUB_DOMAIN_INTERFACE(__TYPE__)\
+ (__TYPE__ *) to##__TYPE__:(NSDictionary *) dic;\
+ (NSDictionary *) dictionaryFrom##__TYPE__:(__TYPE__ *) obj;\
+ (__TYPE__ *) init##__TYPE__;
/*
 *  解析数据字典中的数据到实体上
 */
#define SUB_DOMAIN(__TYPE__)\
+ (__TYPE__ *) to##__TYPE__:(NSDictionary *) dic{\
    return (__TYPE__ *)[self toDomain:[__TYPE__ class] dic:dic];\
}\
+ (NSDictionary *) dictionaryFrom##__TYPE__:(__TYPE__ *) obj{\
    NSMutableDictionary * result = [[NSMutableDictionary alloc] init];\
    if(obj){\
        unsigned int count;\
        Class tClass = [__TYPE__ class];\
        while(![NSObject isSubclassOfClass:tClass]){\
            objc_property_t * properties = class_copyPropertyList(tClass,&count);\
            for(int i=0;i<count;i++){\
                NSString * key = [NSString stringWithUTF8String:property_getName(properties[i])];\
                id value = [obj valueForKey:key];\
                if(value){\
                    [result setObject:value forKey:key];\
                }\
            }\
            tClass = [tClass superclass];\
        }\
    }\
    return result;\
}\
+ (__TYPE__ *) init##__TYPE__{\
    __TYPE__ * result = [[__TYPE__ alloc] init];\
    result.create_time = [Util nowTime];\
    return result;\
}

/*
 *  基本数据类型
 */
@interface BaseDomain : NSObject

CREATE_TYPE_PROPERTY(NSNumber,create_time)

@end


#endif /* BaseDomain_h */
