//
//  DomainFactory.h
//  self
//
//  Created by roy on 16/3/1.
//  Copyright © 2016年 onions. All rights reserved.
//
#import "User.h"
#import "Detail.h"

#ifndef DomainFactory_h
#define DomainFactory_h

@interface DomainFactory : NSObject

BASE_DOMAIN_INTERFACE()

SUB_DOMAIN_INTERFACE(User)
SUB_DOMAIN_INTERFACE(Detail)

@end

#endif /* DomainFactory_h */
