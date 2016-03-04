//
//  Single.h
//  self
//
//  Created by roy on 16/3/1.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "ApiManager.h"
#import "SQLiteOperation.h"

#ifndef Single_h
#define Single_h

@interface Single : NSObject


@property (nonatomic,strong) ApiManager * apiManager;
@property (nonatomic,strong) SQLiteOperation * db;

+ (Single *) sharedInstance;

@end

#endif /* Single_h */