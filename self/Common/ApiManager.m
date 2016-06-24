//
//  ApiManager.m
//  Links
//
//  Created by zeppo on 14-5-17.
//  Copyright (c) 2014年 zhengpeng. All rights reserved.
//

#import "ApiManager.h"
#import "Reachability.h"
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
- (id)getRequestWithMethodName:(NSString *)methodName params:(NSDictionary *)params
{
    NSString *resultMethodName = @"";
    if ([methodName hasPrefix:@"http"]) {
        resultMethodName = methodName;
    }
    NSMutableURLRequest *request = [self.operationManager.requestSerializer requestWithMethod:@"GET" URLString:resultMethodName parameters:params error:nil];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [requestOperation start];
    [requestOperation waitUntilFinished];
    return [requestOperation responseObject];
}
//异步
- (void)asynGetRequestWithMethodName:(NSString *)methodName params:(NSDictionary *)params success:(void (^)(ApiResponse *response))success failure:(void (^)(NSError *error))failure
{
    NSString *resultMethodName = @"";
    if ([methodName hasPrefix:@"http"]) {
        resultMethodName = methodName;
    }
    NSMutableURLRequest *request = [self.operationManager.requestSerializer requestWithMethod:@"GET" URLString:resultMethodName parameters:params error:nil];
    //    if ([AccountInfoManager sharedInstance].userToken) {
    //        [request addValue:[AccountInfoManager sharedInstance].userToken forHTTPHeaderField:@"token"];
    //    }
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
                //log
                //                NSString *eventId = [NSString stringWithFormat:@"api_%@_success",[methodName stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
                //            DLog(@"success eventId is %@",eventId);
                //                [MobClick event:eventId];
            } else {
                response.isSuccess = NO;
                response.failCode = @"";//result[@"failCode"];
                if (result[@"message"]) {
                    response.failMessage = result[@"message"];
                } else {
                    response.failMessage = @"";
                }
                
                //log
                //                NSString *eventId = [NSString stringWithFormat:@"api_%@_fail",[methodName stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
                //                NSDictionary *dictionary = @{@"failCode" : response.failCode, @"failMessage" : response.failMessage};
                //            DLog(@"fail eventId is %@",eventId);
                //                [MobClick event:eventId attributes:dictionary];
            }
        } else {
            response.isSuccess = NO;
            response.failCode = @"";
            response.failMessage = @"请求失败";
            
            //log
            //            NSString *eventId = [NSString stringWithFormat:@"api_%@_fail",[methodName stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
            //            NSDictionary *dictionary = @{@"failCode" : response.failCode, @"failMessage" : response.failMessage};
            //            [MobClick event:eventId attributes:dictionary];
        }
        if ([response.failCode isEqualToString:@"1001"]) {
            //token 失效
            //token无效需要重新登录
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
    
    //    if ([[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultDeviceToken]) {
    //        NSString *deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:UserDefaultDeviceToken];
    //        [mutableDictionary setObject:deviceToken forKey:@"deviceToken"];
    //    }
    
    AFHTTPRequestSerializer * requestSerializer = self.operationManager.requestSerializer;
    if(isJson){
        requestSerializer =[AFJSONRequestSerializer serializer];
    }
    
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"POST" URLString:resultMethodName parameters:mutableDictionary error:nil];
    //    if ([AccountInfoManager sharedInstance].token) {
    //        [request addValue:[AccountInfoManager sharedInstance].token forHTTPHeaderField:@"token"];
    //    }
    
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
                //log
                //                NSString *eventId = [NSString stringWithFormat:@"api_%@_success",[methodName stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
                //                //            DLog(@"success eventId is %@",eventId);
                //                [MobClick event:eventId];
            } else {
                response.isSuccess = NO;
                response.failCode = @"";//result[@"failCode"];
                if (result[@"error"]) {
                    response.failMessage = result[@"error"];
                } else {
                    response.failMessage = @"";
                }
                
                //log
                //                NSString *eventId = [NSString stringWithFormat:@"api_%@_fail",[methodName stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
                //                NSDictionary *dictionary = @{@"failCode" : response.failCode, @"failMessage" : response.failMessage};
                //                //            DLog(@"fail eventId is %@",eventId);
                //                [MobClick event:eventId attributes:dictionary];
            }
        } else {
            response.isSuccess = NO;
            response.failCode = @"";
            response.failMessage = @"请求失败";
            
            //log
            //            NSString *eventId = [NSString stringWithFormat:@"api_%@_fail",[methodName stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
            //            NSDictionary *dictionary = @{@"failCode" : response.failCode, @"failMessage" : response.failMessage};
            //            [MobClick event:eventId attributes:dictionary];
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
            //log
            //            NSString *eventId = [NSString stringWithFormat:@"api_%@_success",[methodName stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
            //            //            DLog(@"success eventId is %@",eventId);
            //            [MobClick event:eventId];
        } else {
            response.isSuccess = NO;
            response.failCode = @"";//result[@"failCode"];
            if (result[@"message"]) {
                response.failMessage = result[@"message"];
            } else {
                response.failMessage = @"";
            }
            
            //log
            //            NSString *eventId = [NSString stringWithFormat:@"api_%@_fail",[methodName stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
            //            NSDictionary *dictionary = @{@"failCode" : response.failCode, @"failMessage" : response.failMessage};
            //            //            DLog(@"fail eventId is %@",eventId);
            //            [MobClick event:eventId attributes:dictionary];
        }
        //        response.rawResult = result;
        //        if ([result[@"status"] isEqualToString:@"OK"]) {
        //            response.isSuccess = YES;
        //            response.result = result[@"filename"];
        //            if (result[@"msg"]) {
        //                response.message = result[@"msg"];
        //            }
        //        } else {
        //            response.isSuccess = NO;
        //            response.failCode = result[@"code"];
        //            response.failMessage = result[@"msg"];
        //        }
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
    return [[Reachability reachabilityForInternetConnection] currentReachabilityStatus]!=NotReachable;
}

@end
