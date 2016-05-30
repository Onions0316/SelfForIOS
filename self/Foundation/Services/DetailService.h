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
- (Detail *) find:(NSNumber *) detailId;
- (BOOL) add:(Detail *) detail;
- (NSArray *) search:(NSNumber *) userId start:(NSNumber *) startTime end:(NSNumber *) endTime type:(NSNumber *) type page:(int) page size:(int) size count:(int *) totalCount title:(NSMutableString*) title;

- (void) totalAll:(NSString *) query rin:(float *) rin rout:(float *) rout;
- (void) search:(NSNumber *) userId year:(int) year month:(int) month tin:(float *) tin tout:(float*) tout;
- (BOOL) removeByIds:(NSArray *) ids;

- (BOOL) mergeByIds:(NSArray *) ids;

- (NSNumber *) count:(NSNumber *) userId;
- (NSString *) happenTimeMin:(NSNumber *) userId;
@end

#endif /* DetailService_h */
