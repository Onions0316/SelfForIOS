//
//  RegisterViewController.h
//  self
//
//  Created by roy on 16/2/29.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "BaseController.h"
#import "User.h"
#ifndef RegisterViewController_h
#define RegisterViewController_h

@interface RegisterViewController : BaseController

CREATE_TYPE_PROPERTY_TO_VIEW(User, updateUser);

@end

#endif /* RegisterViewController_h */
