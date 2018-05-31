//
//  face.cpp
//  SFaceCompare
//
//  Created by Anton Khrolenko on 5/31/18.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//

#include "face.hpp"

cv::Mat faceAlign(cv::Mat inputImage,
                  const dlib::shape_predictor& shapePredictor,
                  cv::CascadeClassifier haarCascadeClassifier,
                  cv::Point2f *faceTemplate,
                  cv::Rect inputFaceRectangle) {
  cv::Mat processedImage;
  std::vector<cv::Rect> facesRects;
  // find face on image if it is needed
  if (inputFaceRectangle.empty()) {
    resize(inputImage, inputImage, 500);
    cv::cvtColor(inputImage, processedImage, cv::COLOR_BGRA2GRAY);
    
    haarCascadeClassifier.detectMultiScale(inputImage, facesRects, 1.1, 2, 0 | cv::CASCADE_SCALE_IMAGE, cv::Size(30, 30));
  }
  else
    facesRects.push_back(inputFaceRectangle);
  // proceed if face was found
  if (facesRects.size() > 0) {
    cv::cvtColor(inputImage, processedImage, cv::COLOR_BGRA2BGR);
    dlib::cv_image<dlib::bgr_pixel> inputImageDlib(processedImage);
    // getting face lanmarks from the image
    dlib::full_object_detection shape = shapePredictor(inputImageDlib, dlib::rectangle(facesRects[0].x,
                                                                                       facesRects[0].y,
                                                                                       facesRects[0].x + facesRects[0].width,
                                                                                       facesRects[0].y + facesRects[0].height));
    // preparing points for the Affine Transform
    cv::Point2f corePoints[3];
    corePoints[0] = cv::Point2f(shape.part(36).x(), shape.part(36).y());
    corePoints[1] = cv::Point2f(shape.part(45).x(), shape.part(45).y());
    corePoints[2] = cv::Point2f(shape.part(33).x(), shape.part(33).y());
    
    cv::Point2f transformPoints[3];
    transformPoints[0] = faceTemplate[36] * 96;
    transformPoints[1] = faceTemplate[45] * 96;
    transformPoints[2] = faceTemplate[33] * 96;
    
    cv::Mat H = cv::getAffineTransform(corePoints, transformPoints);
    cv::Mat thumbnail;
    cv::warpAffine(inputImage, thumbnail, H, cv::Size(96, 96));
    return thumbnail;
  }
  
  return cv::Mat();
}
