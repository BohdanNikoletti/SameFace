//
//  general.cpp
//  SFaceCompare
//
//  Created by Anton Khrolenko on 5/31/18.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//

#include "general.hpp"

void resize(cv::Mat &inputImage, cv::Mat &outputImage, int width, int height, int inter) {
  if (width == NULL && height == NULL) {
    outputImage = inputImage.clone();
    return;
  }
  
  cv::Size dim;
  double r;
  if (width == NULL) {
    r = height / (double)inputImage.rows;
    dim = cv::Size((int)(inputImage.cols * r), height);
  }
  else {
    r = width / (double)inputImage.cols;
    dim = cv::Size(width, (int)(inputImage.rows * r));
  }
  cv::resize(inputImage, outputImage, dim, 0.0, 0.0, inter);
}
