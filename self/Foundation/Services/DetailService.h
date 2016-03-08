//
//  DetailService.h
//  self
//
//  Created by roy on 16/2/29.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "BaseService.h"

#ifndef DetailService_h
#define DetailService_h

@interface DetailService : BaseService
- (BOOL) add:(Detail *) detail;
- (NSArray *) search:(NSNumber *) userId start:(NSNumber *) startTime end:(NSNumber *) endTime type:(NSNumber *) type page:(int) page size:(int) size count:(int *) totalCount;

- (BOOL) removeByIds:(NSArray *) ids;

- (BOOL) mergeByIds:(NSArray *) ids;

- (NSNumber *) count:(NSNumber *) userId;
@end

#endif /* DetailService_h */
