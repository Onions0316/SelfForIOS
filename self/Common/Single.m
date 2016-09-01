//
//  Single.m
//  self
//
//  Created by roy on 16/3/1.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "Single.h"

@implementation Single

- (id) init{
    if(self=[super init]){
        _db = [[SQLiteOperation alloc] init];
        _apiManager = [[ApiManager alloc] init];
        _isTotal = YES;
        _lessThanIOS9 = SYSTEM_VERSION_LESS_THAN(@"9.0");
    }
    return self;
}

+ (Single *) sharedInstance{
    static dispatch_once_t pred;
    static Single * sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[Single alloc] init];
    });
    return sharedInstance;
}

@end