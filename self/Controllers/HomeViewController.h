//
//  HomeController.h
//  self
//
//  Created by roy on 16/2/23.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "BaseController.h"
#import "SlideNavigationController.h"

@interface HomeViewController : BaseController<SlideNavigationControllerDelegate>

- (void) showLoading;

- (void) hideLoading;

@end