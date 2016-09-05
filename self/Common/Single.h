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
@property (nonatomic,assign) BOOL isTotal;
/**版本是否低于ios9*/
@property (nonatomic,assign) BOOL lessThanIOS9;
/**屏幕方向*/
@property (nonatomic,assign) UIInterfaceOrientation uiOrientation;

+ (Single *) sharedInstance;

@end

#endif /* Single_h */
