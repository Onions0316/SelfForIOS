//
//  UserService.h
//  self
//
//  Created by roy on 16/2/29.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "BaseService.h"

#ifndef UserService_h
#define UserService_h

@interface UserService : BaseService

- (User *) login:(NSString *) name password:(NSString *)password;
/*
 *  检查用户名是否存在 存在返回YES
 */
- (BOOL) checkName:(NSString *) name;

/*
 *  新增方法
 */
- (BOOL) add:(User *) user;

/*
 *  更新方法
 */
- (BOOL) update:(User *) user;
@end

#endif /* UserService_h */
