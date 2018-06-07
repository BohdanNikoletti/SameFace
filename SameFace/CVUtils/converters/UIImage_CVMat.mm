//
//  UIImage_CVMat.m
//  SFaceCompare
//
//  Created by Anton Khrolenko on 5/31/18.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//

#include "UIImage_CVMat.h"

@implementation UIImage (OpenCV)

- (cv::Mat)CVMat
{
  CGColorSpaceRef colorSpace = CGImageGetColorSpace(self.CGImage);
  CGFloat cols = self.size.width;
  CGFloat rows = self.size.height;
  
  cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
  
  CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                  cols,                       // Width of bitmap
                                                  rows,                       // Height of bitmap
                                                  8,                          // Bits per component
                                                  cvMat.step[0],              // Bytes per row
                                                  colorSpace,                 // Colorspace
                                                  kCGImageAlphaNoneSkipLast |
                                                  kCGBitmapByteOrderDefault); // Bitmap info flags
  
  CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), self.CGImage);
  CGContextRelease(contextRef);
  
  cv::cvtColor(cvMat, cvMat, CV_RGBA2BGRA);
  return cvMat;
}

- (cv::Mat)CVMat3
{
  cv::Mat result = [self CVMat];
  cv::cvtColor(result, result, CV_BGRA2BGR);
  return result;
  
}

+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat {
  if(cvMat.cols == 0 and cvMat.rows == 0)
    return nil;
  NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
  
  CGColorSpaceRef colorSpace;
  CGBitmapInfo bitmapInfo;
  
  if (cvMat.elemSize() == 1) {
    colorSpace = CGColorSpaceCreateDeviceGray();
    bitmapInfo = kCGImageAlphaNone | kCGBitmapByteOrderDefault;
  } else {
    colorSpace = CGColorSpaceCreateDeviceRGB();
    bitmapInfo = kCGBitmapByteOrder32Little | (
                                               cvMat.elemSize() == 3? kCGImageAlphaNone : kCGImageAlphaNoneSkipFirst
                                               );
  }
  
  CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
  
  // Creating CGImage from cv::Mat
  CGImageRef imageRef = CGImageCreate(
                                      cvMat.cols,                 //width
                                      cvMat.rows,                 //height
                                      8,                          //bits per component
                                      8 * cvMat.elemSize(),       //bits per pixel
                                      cvMat.step[0],              //bytesPerRow
                                      colorSpace,                 //colorspace
                                      bitmapInfo,                 // bitmap info
                                      provider,                   //CGDataProviderRef
                                      NULL,                       //decode
                                      false,                      //should interpolate
                                      kCGRenderingIntentDefault   //intent
                                      );
  
  // Getting UIImage from CGImage
  UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
  CGImageRelease(imageRef);
  CGDataProviderRelease(provider);
  CGColorSpaceRelease(colorSpace);
  
  return finalImage;
}

@end
