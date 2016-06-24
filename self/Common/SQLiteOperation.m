//
//  SQLiteOperation.m
//  PageBaseTest
//
//  Created by roy on 16/1/28.
//  Copyright © 2016年 roy. All rights reserved.
//

#import "SQLiteOperation.h"


@interface SQLiteOperation()

@property (nonatomic,strong) NSString * dataSourceName;


@end

@implementation SQLiteOperation

- (id) init{
    if(self=[super init]){
        //初始化数据库文件地址(沙盒)
        //NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //NSString *documentsDirectory = [paths objectAtIndex:0];
        //NSLog(@"%@,%@",documentsDirectory,[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]);
        //NSString * documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        //获取配置文件里数据库名称
        NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        NSDictionary* infoDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        self.dataSourceName = [infoDic objectForKey:@"Data Source Name"];
        //NSLog(@"data source name is :%@",self.dataSourceName);
        
        if(self.dataSourceName!=nil){
            self.path = [[Util documentPath] stringByAppendingPathComponent:self.dataSourceName];
            //NSLog(@"data source path is :%@",self.path);
        }else{
            NSLog(@"data file name read error");
        }
    }
    return self;
}

- (BOOL) readyDatabase{
    NSError * error;
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:self.path];
    //如果数据库文件存在则返回   不存在就复制默认数据库文件到指定路径
    if(!success){
        NSString * defaultDataPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.dataSourceName];
        success = [fileManager copyItemAtPath:defaultDataPath toPath:self.path error:&error];
        NSAssert1(success, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    if(self.dbInitSql){
        //self.dbInitSql = [self.dbInitSql stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        for(NSString * str in [self.dbInitSql componentsSeparatedByString:@";"]){
            [self eval:str params:nil];
        }
        success = YES;
        //NSLog(@"%@",self.dbInitSql);
    }
    return success;
}

- (NSArray<NSDictionary *> *)selectData:(NSString *) sql{
    //[self readyDatabase];
    NSMutableArray* result = [[NSMutableArray alloc] init];
    if([sql hasValue]){
        if(sqlite3_open([self.path UTF8String], &database)==SQLITE_OK){
            //能够使用sqlite3_step 执行的编译好的准备语句的指针
            sqlite3_stmt * statement = nil;
            //准备执行sql  但并没有执行
            if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL)== SQLITE_OK){
                //逐条读取纪录
                while(sqlite3_step(statement)==SQLITE_ROW){
                    //读取数据
                    int count = sqlite3_column_count(statement);
                    NSMutableDictionary * row = [[NSMutableDictionary alloc] init];
                    for(int i=0;i<count;i++){
                        const unsigned char * value = sqlite3_column_text(statement, i);
                        if(value){
                            [row setObject:[NSString stringWithUTF8String:value] forKey:[NSString stringWithFormat:@"%s",sqlite3_column_name(statement, i)]];
                        }
                    }
                    [result addObject:row];
                }
            }else{
                NSLog(@"error : failed to prepare");
            }
            //释放对象
            sqlite3_finalize(statement);
        }
        else{
            NSLog(@"failed to open database with message '%s'",sqlite3_errmsg(database));
        }
        sqlite3_close(database);
    }
    return result;
}

- (BOOL) eval:(NSString *)sql params:(NSArray *)params{
    //[self readyDatabase];
    if([sql hasValue]){
        int success;
        if(sqlite3_open([self.path UTF8String], &database)==SQLITE_OK){
            //能够使用sqlite3_step 执行的编译好的准备语句的指针
            sqlite3_stmt * statement = nil;
            //准备执行sql  但并没有执行
            int state = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
            if(state == SQLITE_OK){
                if(params!=nil){
                    int count = params.count;
                    if(count>0){
                        for(int i=0;i<count;i++){
                            NSString * temp = params[i];
                            sqlite3_bind_text(statement, i+1, [temp UTF8String], -1, SQLITE_TRANSIENT);
                        }
                    }
                }
                success = sqlite3_step(statement);
                if(success==SQLITE_ERROR){
                    NSLog(@"error: failed to eval sql,error code:%d",success);
                }
            }else{
                NSLog(@"error : failed to prepare");
            }
            //释放对象
            sqlite3_finalize(statement);
        }
        else{
            NSLog(@"failed to open database with message '%s'",sqlite3_errmsg(database));
        }
        sqlite3_close(database);
        return success==SQLITE_OK || success==SQLITE_DONE;
    }
    return NO;
}

@end
