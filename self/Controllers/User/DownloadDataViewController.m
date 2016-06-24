//
//  DownloadDataViewController.m
//  self
//
//  Created by roy on 16/6/24.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "DownloadDataViewController.h"

@interface DownloadDataViewController()<UIAlertViewDelegate>

CREATE_TYPE_PROPERTY_TO_VIEW(UITextField, name)

@end

@implementation DownloadDataViewController

- (id) init{
    if(self=[super init]){
        super.navTitle = DownloadData;
        super.checkLogin = NO;
    }
    return self;
}

- (void) viewDidLoad{
    [super viewDidLoad];
    
    CGFloat top = self.topSize;
    CGFloat left = Default_View_Space;
    
    self.name=[UIUtil addTextFiledInView:self.view rect:CGRectMake(left, top + left, 0, Default_Label_Height) tag:0];
    self.name.width = self.view.width - 2*left;
    self.name.placeholder = @"地址";
    self.name.text = @"http://192.168.0.59:8081/test/self.db";

    CGFloat btnWidth = (self.view.width-3*Default_View_Space)/2;
    
    UIButton * downloadData = [UIUtil addButtonInView:self.view title:@"下载" rect:CGRectMake(left, self.name.bottom+left, btnWidth, Default_Label_Height) sel:@selector(downloadDataTap) controller:self tag:0];
    downloadData.right = self.view.width - left;
    
}


- (void) downloadDataTap{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"下载数据会覆盖原有数据,请慎重使用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"下载并覆盖", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.view showLoading];
    if(buttonIndex==1){
        NSData * data = [[[Single sharedInstance] apiManager] getRequestWithMethodName:self.name.text params:nil];
        if(data){
            NSString * path = [[[Single sharedInstance] db] path];
            NSError * error;
            NSFileManager * fileManager = [NSFileManager defaultManager];
            //删除原数据库
            BOOL success = [fileManager removeItemAtPath:path error:&error];
            NSAssert1(success, @"Failed remove database file with message '%@'.", [error localizedDescription]);
            if([data writeToFile:path atomically:YES]){
                [self showAlert:@"" message:@"保存成功" controller:self];
            }else{
                [[[Single sharedInstance] db] readyDatabase];
                [self showAlert:@"" message:@"保存失败" controller:self];
            }
        }
    }
    [self.view hideLoading];
}

@end