//
//  SQLiteOperation.h
//  PageBaseTest
//
//  Created by roy on 16/1/28.
//  Copyright © 2016年 roy. All rights reserved.
//

#ifndef SQLiteOperation_h
#define SQLiteOperation_h

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Util.h"

typedef void (^sqliteDbInit) ();

@interface SQLiteOperation : NSObject{
    sqlite3 *database;
}

@property (nonatomic,strong) NSString * path;

@property (nonatomic,strong) NSString * dbInitSql;

- (void) readyDatabase;
- (NSArray *)selectData:(NSString *) sql;
- (BOOL) eval:(NSString *)sql params:(NSArray *)params;

@end

#endif /* SQLiteOperation_h */
