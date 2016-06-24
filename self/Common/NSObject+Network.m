//
//  NSObject+Network.m
//  LinksDriver
//
//  Created by wyf on 15/3/3.
//  Copyright (c) 2015年 wyf. All rights reserved.
//

#import "NSObject+Network.h"

@implementation NSObject(Network)

- (id)BIF_defaultValue:(id)defaultData
{
    if (![defaultData isKindOfClass:[self class]]) {
        return defaultData;
    }
    
    if ([self BIF_isEmptyObject]) {
        return defaultData;
    }
    
    return self;
}

- (BOOL)BIF_isEmptyObject
{
    if ([self isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString *)self length] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSArray class]]) {
        if ([(NSArray *)self count] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        if ([(NSDictionary *)self count] == 0) {
            return YES;
        }
    }
    
    return NO;
}

- (NSString *)jsonString
{
    if (![self isKindOfClass:[NSDictionary class]] &&
        ![self isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0
                                                         error:&error];
    if (error) {
        NSLog(@"json convert error, object = %@", self);
        return nil;
    }
    
    return [[NSString alloc] initWithData:jsonData
                                 encoding:NSUTF8StringEncoding];
}


+ (instancetype)jsonObjectWithString:(NSString *)jsonStr
{
    if (!jsonStr) {
        NSLog(@"你妹，什么破 json: %@", jsonStr);
        return nil;
    }
    NSError *error = nil;
    id v = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]
                                           options:NSJSONReadingMutableContainers
                                             error:&error];
    if (error) {
        NSLog(@"你妹，什么破 json: %@", jsonStr);
        return @{@"msg":jsonStr};
    }
    
    return v;
}

@end
