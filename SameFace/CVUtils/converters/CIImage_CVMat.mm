//
//  CIImage_CVMat.m
//  SFaceCompare
//
//  Created by Anton Khrolenko on 5/31/18.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//

#include "CIImage_CVMat.h"

@implementation CIImage (OpenCV)

- (cv::Mat)CVMat
{
  CGImage *imageData = [[CIContext contextWithOptions:nil] createCGImage:self fromRect:[self extent]];
  CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageData);
  CGFloat cols = self.extent.size.width;
  CGFloat rows = self.extent.size.height;
  
  cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
  
  CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                  cols,                       // Width of bitmap
                                                  rows,                       // Height of bitmap
                                                  8,                          // Bits per component
                                                  cvMat.step[0],              // Bytes per row
                                                  colorSpace,                 // Colorspace
                                                  kCGImageAlphaNoneSkipLast |
                                                  kCGBitmapByteOrderDefault); // Bitmap info flags
  
  CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), imageData);
  CGContextRelease(contextRef);
  CGImageRelease(imageData);
  
  cv::cvtColor(cvMat, cvMat, cv::COLOR_RGBA2BGRA);
  return cvMat;
}

- (cv::Mat)CVMat3
{
  cv::Mat result = [self CVMat];
  cv::cvtColor(result, result, cv::COLOR_BGRA2BGR);
  return result;
}

@end
