//
//  NSObject+Network.h
//  LinksDriver
//
//  Created by wyf on 15/3/3.
//  Copyright (c) 2015年 wyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(Network)

- (id)BIF_defaultValue:(id)defaultData;
- (BOOL)BIF_isEmptyObject;
- (NSString *)jsonString;
+ (instancetype)jsonObjectWithString:(NSString *)jsonStr;

@end
