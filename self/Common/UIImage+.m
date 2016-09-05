//
//  UIImage+.m
//  self
//
//  Created by 彭颖 on 16/9/5.
//  Copyright © 2016年 onions. All rights reserved.
//


#import "UIImage+.h"

@implementation UIImage(ext)

/**通过颜色创建图片*/
+ (UIImage *) imageWithColor:(UIColor*)color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark 二维码
+ (UIImage*) createARCode:(NSString *) url{
    return [self createARCode:url withSize:150 beforColor:[UIColor blackColor] backColor:[UIColor whiteColor]];
}

/**生成二维码 @param url 地址 @param size 二维码宽度 @param beforColor 前景色 @param backColor 背景色*/
+ (UIImage*) createARCode:(NSString *) url withSize:(CGFloat) size beforColor:(UIColor *) beforColor backColor:(UIColor *) backColor{
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认
    [filter setDefaults];
    
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    NSString *dataString = url;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4.获取输出的二维码
    CIImage *image = [filter outputImage];
    
    // 5.显示二维码
    
    //因为生成的二维码模糊，所以通过createNonInterpolatedUIImageFormCIImage:outputImage来获得高清的二维码图片
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    
    size_t bytesPerRow = width * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * height);
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapRef = CGBitmapContextCreate(rgbImageBuf, width, height, 8, bytesPerRow, cs, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    //Traverse pixe
    int pixelNum = width * height;
    uint32_t* pCurPtr = rgbImageBuf;
    CIColor * cBefor = [CIColor colorWithCGColor:beforColor.CGColor];
    int beforRed = cBefor.red * 0xff;
    int beforGreen = cBefor.green * 0xff;
    int beforBlue = cBefor.blue * 0xff;
    CIColor * cBack = [CIColor colorWithCGColor:backColor.CGColor];
    int backRed = cBack.red * 0xff;
    int backGreen = cBack.green * 0xff;
    int backBlue = cBack.blue * 0xff;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            //Change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = beforRed; //0~255 //红
            ptr[2] = beforGreen;//绿
            ptr[1] = beforBlue;//蓝
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = backRed; //0~255 //红
            ptr[2] = backGreen;//绿
            ptr[1] = backBlue;//蓝
        }
    }
    // 2.保存bitmap到图片
    //Convert to image
    CGDataProviderRef dataProviderRef = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * height, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(width, height, 8, 32, bytesPerRow, cs,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProviderRef,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProviderRef);
    return [UIImage imageWithCGImage:imageRef];
}

void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

@end