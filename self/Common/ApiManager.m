//
//  ApiManager.m
//  Links
//
//  Created by zeppo on 14-5-17.
//  Copyright (c) 2014年 zhengpeng. All rights reserved.
//

#import "ApiManager.h"
#import "GTMBase64.h"
#import "NSObject+Network.h"
#import "Reachability.h"

@interface ApiManager ()
@property (nonatomic, strong) NSMutableArray *webImageOperationArray;

@end

@implementation ApiManager

- (void)dealloc
{
    //取消队列中所有请求
    [self.operationManager.operationQueue cancelAllOperations];
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

- (void)asynGetRequestWithMethodName:(NSString *)methodName params:(NSDictionary *)params success:(void (^)(ApiResponse *response))success failure:(void (^)(NSError *error))failure
{
    NSString *resultMethodName = @"";
    if ([methodName hasPrefix:@"http"]) {
        resultMethodName = methodName;
    } else {
        //resultMethodName = [NSString stringWithFormat:@"%@%@",API_URL_PREFIX,methodName];
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
        success(response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];
    
    [self.operationManager.operationQueue addOperation:operation];
    
}


- (void)asynPostRequestWithMethodName:(NSString *)methodName params:(NSDictionary *)params success:(void (^)(ApiResponse *response))success failure:(void (^)(NSError *error))failure
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
    
    
    NSMutableURLRequest *request = [self.operationManager.requestSerializer requestWithMethod:@"POST" URLString:resultMethodName parameters:mutableDictionary error:nil];
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
- (void)cancelAllRequest{
    //取消队列中所有请求
    [self.operationManager.operationQueue cancelAllOperations];
}

+ (BOOL)hasNetwork
{
    return [[Reachability reachabilityForInternetConnection] currentReachabilityStatus]!=NotReachable;
    //return YES;
}

@end
