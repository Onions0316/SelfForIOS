//
//  ApiManager.h
//  Links
//
//  Created by zeppo on 14-5-17.
//  Copyright (c) 2014年 zhengpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiResponse.h"
#import "AFHTTPRequestOperationManager.h"

@interface ApiManager : NSObject
@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;
- (AFHTTPRequestOperation*)getRequestWithMethodName:(NSString *)methodName params:(NSDictionary *)params;
- (void)asynGetRequestWithMethodName:(NSString *)methodName params:(NSDictionary *)params success:(void (^)(ApiResponse *response))success failure:(void (^)(NSError *error))failure;

//异步post请求
- (void)asynPostRequestWithMethodName:(NSString *)methodName params:(NSDictionary *)params success:(void (^)(ApiResponse *response))success failure:(void (^)(NSError *error))failure;
//异步post json请求
- (void)asynPostRequestWithMethodName:(NSString *)methodName params:(NSDictionary *)params json:(BOOL) isJson success:(void (^)(ApiResponse *response))success failure:(void (^)(NSError *error))failure;
//异步下载图片
- (void)asynDownloadImage:(NSString *)urlString tag:(NSInteger)tag success:(void (^)(UIImage *image, NSInteger tag))success failure:(void (^)(NSError *error, NSInteger tag))failure;

- (void)asynPostImageRequestWithMethodName:(NSString *)methodName data:(NSData *) data success:(void (^)(ApiResponse *response))success failure:(void (^)(NSError *error))failure;

//取消请求
- (void)cancelAllRequest;

//判断是否有网络
+ (BOOL)hasNetwork;

@end
