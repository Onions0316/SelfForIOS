//
//  ApiManager.m
//  Links
//
//  Created by zeppo on 14-5-17.
//  Copyright (c) 2014年 zhengpeng. All rights reserved.
//

#import "ApiManager.h"
#import "GTMBase64.h"
#import "SDWebImageManager.h"
#import "NSObject+Network.h"

@interface ApiManager ()
@property (nonatomic, strong) NSMutableArray *webImageOperationArray;

@end

@implementation ApiManager

- (void)dealloc
{
    //取消队列中所有请求
    [self.operationManager.operationQueue cancelAllOperations];
    
    //取消图片下载
    for (id <SDWebImageOperation> webImageOperation in self.webImageOperationArray) {
        [webImageOperation cancel];
    }
}

- (AFHTTPRequestOperationManager *)operationManager
{
    if (_operationManager == nil) {
        _operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:nil];
        //        _operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _operationManager.responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
        _operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _operationManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.webImageOperationArray = [NSMutableArray array];
    }
    return self;
}
//同步
- (ApiResponse*)getRequestWithMethodName:(NSString *)methodName params:(NSDictionary *)params
{
    NSString *resultMethodName = @"";
    if ([methodName hasPrefix:@"http"]) {
        resultMethodName = methodName;
    }
    NSMutableURLRequest *request = [self.operationManager.requestSerializer requestWithMethod:@"GET" URLString:resultMethodName parameters:params error:nil];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [requestOperation start];
    [requestOperation waitUntilFinished];
    return [self formatResponseString:requestOperation];
}

- (ApiResponse*)postRequestWithMethodName:(NSString *)methodName params:(NSDictionary *)params
{
    NSString *resultMethodName = @"";
    if ([methodName hasPrefix:@"http"]) {
        resultMethodName = methodName;
    }
    NSMutableURLRequest *request = [self requestByParams:params resultMethodName:resultMethodName];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [requestOperation start];
    [requestOperation waitUntilFinished];
    return [self formatResponseString:requestOperation];
}

- (NSMutableURLRequest*) requestByParams:(NSDictionary*) params resultMethodName:(NSString *)resultMethodName{
    BOOL isUpload = NO;
    if (params && [params allValues].count > 0) {
        for (id value in [params allValues]) {
            if (value){
                if ([value isKindOfClass:[NSData class]]){
                    isUpload = YES;
                    break;
                }
            }
        }
    }
    if(isUpload){
        //创建Request对象
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:resultMethodName]];
        [request setHTTPMethod:@"POST"];
        NSMutableData *body = [NSMutableData data];
        
        //设置表单项分隔符
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        
        //设置内容类型
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        for(NSString * key in [params allKeys]){
            id value = params[key];
            if([key isEqualToString:File_Name_Param]){
                continue;
            }
            if([value isKindOfClass:[NSData class]]){
                NSString * path = params[File_Name_Param];
                //写入图片的内容
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",key,[path lastPathComponent]] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",[Util mimeTypeForPath:path]] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:value];
                [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                
            }else{
                //写入INFO的内容
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
            }
        }
        //写入尾部内容
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:body];
        return request;
    }
    else{
        return [self.operationManager.requestSerializer requestWithMethod:@"POST" URLString:resultMethodName parameters:params error:nil];
    }
}

- (ApiResponse*) formatResponseString:(AFHTTPRequestOperation *)requestOperation{
    ApiResponse *response = [[ApiResponse alloc] init];
    NSString *responseString = [requestOperation.responseString stringByReplacingOccurrencesOfString:@"0000-00-00 00:00" withString:@"2000-01-01 00:00"];
    NSDictionary *result = (NSDictionary *)[NSObject jsonObjectWithString:responseString];
    if (result) {
        NSString * err = [result[@"error_description"] description];
        if ([result isKindOfClass:[NSArray class]] || ![err hasValue]) {
            response.isSuccess = YES;
            if (result) {
                response.result = result;
            }
        } else {
            response.isSuccess = NO;
            response.failCode = @"";//result[@"failCode"];
            if ([err hasValue]) {
                response.failMessage = err;
            } else {
                response.failMessage = @"";
            }
        }
    } else {
        response.isSuccess = NO;
        response.failCode = @"";
        response.failMessage = @"";
    }
    return response;
}
//异步
- (void)asynGetRequestWithMethodName:(NSString *)methodName params:(NSDictionary *)params success:(void (^)(ApiResponse *response))success failure:(void (^)(NSError *error))failure
{
    NSString *resultMethodName = @"";
    if ([methodName hasPrefix:@"http"]) {
        resultMethodName = methodName;
    }
    NSMutableURLRequest *request = [self.operationManager.requestSerializer requestWithMethod:@"GET" URLString:resultMethodName parameters:params error:nil];
    AFHTTPRequestOperation *operation = [self.operationManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *responseString = [operation.responseString stringByReplacingOccurrencesOfString:@"0000-00-00 00:00" withString:@"2000-01-01 00:00"];
        
        NSDictionary *result = (NSDictionary *)[NSObject jsonObjectWithString:responseString];
        ApiResponse *response = [[ApiResponse alloc] init];
        
        if (result) {
            if ([result isKindOfClass:[NSArray class]] || !result[@"error"]) {
                response.isSuccess = YES;
                response.result = result;
                if (result) {
                    response.result = result;
                }
            } else {
                response.isSuccess = NO;
                response.failCode = @"";//result[@"failCode"];
                if (result[@"message"]) {
                    response.failMessage = result[@"message"];
                } else {
                    response.failMessage = @"";
                }
            }
        } else {
            response.isSuccess = NO;
            response.failCode = @"";
            response.failMessage = @"请求失败";
        }
        success(response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    [self.operationManager.operationQueue addOperation:operation];
    
}
//异步
- (void)asynPostRequestWithMethodName:(NSString *)methodName params:(NSDictionary *)params success:(void (^)(ApiResponse *response))success failure:(void (^)(NSError *error))failure
{
    [self asynPostRequestWithMethodName:methodName params:params json:NO success:success failure:failure];
}

- (void)asynPostRequestWithMethodName:(NSString *)methodName params:(NSDictionary *)params json:(BOOL) isJson success:(void (^)(ApiResponse *response))success failure:(void (^)(NSError *error))failure
{
    NSString *resultMethodName = methodName;//[NSString stringWithFormat:@"%@%@",API_URL_PREFIX,methodName];
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    if (params && [params allKeys].count > 0) {
        for (NSString *key in [params allKeys]) {
            id value = [params objectForKey:key];
            if (value){
                if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
                    //                    value = [value jsonString];
                    [mutableDictionary setObject:value forKey:key];
                } else if ([value isKindOfClass:[NSData class]]) {
                    value = [GTMBase64 stringByEncodingData:value];
                    [mutableDictionary setObject:value forKey:key];
                } else {
                    [mutableDictionary setObject:value forKey:key];
                }
            }
        }
    }
    AFHTTPRequestSerializer * requestSerializer = self.operationManager.requestSerializer;
    if(isJson){
        requestSerializer =[AFJSONRequestSerializer serializer];
    }
    
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"POST" URLString:resultMethodName parameters:mutableDictionary error:nil];
    AFHTTPRequestOperation *operation = [self.operationManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *responseString = [operation.responseString stringByReplacingOccurrencesOfString:@"0000-00-00 00:00" withString:@"2000-01-01 00:00"];
        
        NSDictionary *result = (NSDictionary *)[NSObject jsonObjectWithString:responseString];
        ApiResponse *response = [[ApiResponse alloc] init];
        
        if (result) {
            if ([result isKindOfClass:[NSArray class]] || !result[@"error"]) {
                response.isSuccess = YES;
                response.result = result;
                if (result) {
                    response.result = result;
                }
            } else {
                response.isSuccess = NO;
                response.failCode = @"";//result[@"failCode"];
                if (result[@"error"]) {
                    response.failMessage = result[@"error"];
                } else {
                    response.failMessage = @"";
                }
            }
        } else {
            response.isSuccess = NO;
            response.failCode = @"";
            response.failMessage = @"请求失败";
        }
        success(response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    [self.operationManager.operationQueue addOperation:operation];
    
}

- (void)asynDownloadImage:(NSString *)urlString tag:(NSInteger)tag success:(void (^)(UIImage *image, NSInteger tag))success failure:(void (^)(NSError *error, NSInteger tag))failure
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    id <SDWebImageOperation> webImageOperation = [manager downloadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //显示当前进度
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (error) {
            failure(error,tag);
        } else {
            success(image,tag);
        }
    }];
    [self.webImageOperationArray addObject:webImageOperation];
    
}

- (void)asynPostImageRequestWithMethodName:(NSString *)methodName data:(NSData *) data success:(void (^)(ApiResponse *response))success failure:(void (^)(NSError *error))failure
{
    [self.operationManager POST:methodName parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:@"file.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)[NSObject jsonObjectWithString:operation.responseString];
        ApiResponse *response = [[ApiResponse alloc] init];
        if ([result[@"result"] intValue] == 0) {
            response.isSuccess = YES;
            response.result = result;
            if (result) {
                response.result = result;
            }
        } else {
            response.isSuccess = NO;
            response.failCode = @"";//result[@"failCode"];
            if (result[@"message"]) {
                response.failMessage = result[@"message"];
            } else {
                response.failMessage = @"";
            }
        }
        success(response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         failure(error);
     }];
}

- (void)cancelAllRequest{
    //取消队列中所有请求
    [self.operationManager.operationQueue cancelAllOperations];
    
    //取消图片下载
    for (id <SDWebImageOperation> webImageOperation in self.webImageOperationArray) {
        [webImageOperation cancel];
    }
    
}

+ (BOOL)hasNetwork
{
    return [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] !=AFNetworkReachabilityStatusNotReachable;
}

@end
