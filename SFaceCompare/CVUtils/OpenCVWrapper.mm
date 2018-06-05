//
//  OpenCVWrapper.m
//  SFaceCompare
//
//  Created by Anton Khrolenko on 5/31/18.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//

#import "OpenCVWrapper.h"

//#import <opencv2/opencv.hpp>
#include <dlib/image_processing.h>
#include <dlib/image_processing/frontal_face_detector.h>

@implementation OpenCVWrapper

dlib::shape_predictor faceShapePredictor;
cv::CascadeClassifier faceCascade;
cv::Point2f FACE_ALIGN_TEMPLATE[68];

- (instancetype) init {
  self = [super init];
//  NSBundle* sdkBundle = [NSBundle bundleForClass:[self class]];
//  NSString *dir = [sdkBundle resourcePath];
//  const char *cpath = [dir fileSystemRepresentation];
//  std::string homePath(cpath);
  
//  dlib::deserialize(homePath + "/shape_predictor_68_face_landmarks.xml") >> faceShapePredictor;
//  faceCascade.load(homePath + "/haarcascade_frontalface_alt.xml");
  
  FACE_ALIGN_TEMPLATE[0] = cv::Point2f(0.0792396913815, 0.339223741112);  FACE_ALIGN_TEMPLATE[1] = cv::Point2f(0.0829219487236, 0.456955367943);
  FACE_ALIGN_TEMPLATE[2] = cv::Point2f(0.0967927109165, 0.575648016728);  FACE_ALIGN_TEMPLATE[3] = cv::Point2f(0.122141515615, 0.691921601066);
  FACE_ALIGN_TEMPLATE[4] = cv::Point2f(0.168687863544, 0.800341263616);   FACE_ALIGN_TEMPLATE[5] = cv::Point2f(0.239789390707, 0.895732504778);
  FACE_ALIGN_TEMPLATE[6] = cv::Point2f(0.325662452515, 0.977068762493);   FACE_ALIGN_TEMPLATE[7] = cv::Point2f(0.422318282013, 1.04329000149);
  FACE_ALIGN_TEMPLATE[8] = cv::Point2f(0.531777802068, 1.06080371126);    FACE_ALIGN_TEMPLATE[9] = cv::Point2f(0.641296298053, 1.03981924107);
  FACE_ALIGN_TEMPLATE[10] = cv::Point2f(0.738105872266, 0.972268833998);  FACE_ALIGN_TEMPLATE[11] = cv::Point2f(0.824444363295, 0.889624082279);
  FACE_ALIGN_TEMPLATE[12] = cv::Point2f(0.894792677532, 0.792494155836);  FACE_ALIGN_TEMPLATE[13] = cv::Point2f(0.939395486253, 0.681546643421);
  FACE_ALIGN_TEMPLATE[14] = cv::Point2f(0.96111933829, 0.562238253072);   FACE_ALIGN_TEMPLATE[15] = cv::Point2f(0.970579841181, 0.441758925744);
  FACE_ALIGN_TEMPLATE[16] = cv::Point2f(0.971193274221, 0.322118743967);  FACE_ALIGN_TEMPLATE[17] = cv::Point2f(0.163846223133, 0.249151738053);
  FACE_ALIGN_TEMPLATE[18] = cv::Point2f(0.21780354657, 0.204255863861);   FACE_ALIGN_TEMPLATE[19] = cv::Point2f(0.291299351124, 0.192367318323);
  FACE_ALIGN_TEMPLATE[20] = cv::Point2f(0.367460241458, 0.203582210627);  FACE_ALIGN_TEMPLATE[21] = cv::Point2f(0.4392945113, 0.233135599851);
  FACE_ALIGN_TEMPLATE[22] = cv::Point2f(0.586445962425, 0.228141644834);  FACE_ALIGN_TEMPLATE[23] = cv::Point2f(0.660152671635, 0.195923841854);
  FACE_ALIGN_TEMPLATE[24] = cv::Point2f(0.737466449096, 0.182360984545);  FACE_ALIGN_TEMPLATE[25] = cv::Point2f(0.813236546239, 0.192828009114);
  FACE_ALIGN_TEMPLATE[26] = cv::Point2f(0.8707571886, 0.235293377042);    FACE_ALIGN_TEMPLATE[27] = cv::Point2f(0.51534533827, 0.31863546193);
  FACE_ALIGN_TEMPLATE[28] = cv::Point2f(0.516221448289, 0.396200446263);  FACE_ALIGN_TEMPLATE[29] = cv::Point2f(0.517118861835, 0.473797687758);
  FACE_ALIGN_TEMPLATE[30] = cv::Point2f(0.51816430343, 0.553157797772);   FACE_ALIGN_TEMPLATE[31] = cv::Point2f(0.433701156035, 0.604054457668);
  FACE_ALIGN_TEMPLATE[32] = cv::Point2f(0.475501237769, 0.62076344024);   FACE_ALIGN_TEMPLATE[33] = cv::Point2f(0.520712933176, 0.634268222208);
  FACE_ALIGN_TEMPLATE[34] = cv::Point2f(0.565874114041, 0.618796581487);  FACE_ALIGN_TEMPLATE[35] = cv::Point2f(0.607054002672, 0.60157671656);
  FACE_ALIGN_TEMPLATE[36] = cv::Point2f(0.252418718401, 0.331052263829);  FACE_ALIGN_TEMPLATE[37] = cv::Point2f(0.298663015648, 0.302646354002);
  FACE_ALIGN_TEMPLATE[38] = cv::Point2f(0.355749724218, 0.303020650651);  FACE_ALIGN_TEMPLATE[39] = cv::Point2f(0.403718978315, 0.33867711083);
  FACE_ALIGN_TEMPLATE[40] = cv::Point2f(0.352507175597, 0.349987615384);  FACE_ALIGN_TEMPLATE[41] = cv::Point2f(0.296791759886, 0.350478978225);
  FACE_ALIGN_TEMPLATE[42] = cv::Point2f(0.631326076346, 0.334136672344);  FACE_ALIGN_TEMPLATE[43] = cv::Point2f(0.679073381078, 0.29645404267);
  FACE_ALIGN_TEMPLATE[44] = cv::Point2f(0.73597236153, 0.294721285802);   FACE_ALIGN_TEMPLATE[45] = cv::Point2f(0.782865376271, 0.321305281656);
  FACE_ALIGN_TEMPLATE[46] = cv::Point2f(0.740312274764, 0.341849376713);  FACE_ALIGN_TEMPLATE[47] = cv::Point2f(0.68499850091, 0.343734332172);
  FACE_ALIGN_TEMPLATE[48] = cv::Point2f(0.353167761422, 0.746189164237);  FACE_ALIGN_TEMPLATE[49] = cv::Point2f(0.414587777921, 0.719053835073);
  FACE_ALIGN_TEMPLATE[50] = cv::Point2f(0.477677654595, 0.706835892494);  FACE_ALIGN_TEMPLATE[51] = cv::Point2f(0.522732900812, 0.717092275768);
  FACE_ALIGN_TEMPLATE[52] = cv::Point2f(0.569832064287, 0.705414478982);  FACE_ALIGN_TEMPLATE[53] = cv::Point2f(0.635195811927, 0.71565572516);
  FACE_ALIGN_TEMPLATE[54] = cv::Point2f(0.69951672331, 0.739419187253);   FACE_ALIGN_TEMPLATE[55] = cv::Point2f(0.639447159575, 0.805236879972);
  FACE_ALIGN_TEMPLATE[56] = cv::Point2f(0.576410514055, 0.835436670169);  FACE_ALIGN_TEMPLATE[57] = cv::Point2f(0.525398405766, 0.841706377792);
  FACE_ALIGN_TEMPLATE[58] = cv::Point2f(0.47641545769, 0.837505914975);   FACE_ALIGN_TEMPLATE[59] = cv::Point2f(0.41379548902, 0.810045601727);
  FACE_ALIGN_TEMPLATE[60] = cv::Point2f(0.380084785646, 0.749979603086);  FACE_ALIGN_TEMPLATE[61] = cv::Point2f(0.477955996282, 0.74513234612);
  FACE_ALIGN_TEMPLATE[62] = cv::Point2f(0.523389793327, 0.748924302636);  FACE_ALIGN_TEMPLATE[63] = cv::Point2f(0.571057789237, 0.74332894691);
  FACE_ALIGN_TEMPLATE[64] = cv::Point2f(0.672409137852, 0.744177032192);  FACE_ALIGN_TEMPLATE[65] = cv::Point2f(0.572539621444, 0.776609286626);
  FACE_ALIGN_TEMPLATE[66] = cv::Point2f(0.5240106503, 0.783370783245);    FACE_ALIGN_TEMPLATE[67] = cv::Point2f(0.477561227414, 0.778476346951);
  
  float minX = FACE_ALIGN_TEMPLATE[0].x, maxX = FACE_ALIGN_TEMPLATE[0].x;
  float minY = FACE_ALIGN_TEMPLATE[0].y, maxY = FACE_ALIGN_TEMPLATE[0].y;
  for (char i = 1; i < 68; i++) {
    if (FACE_ALIGN_TEMPLATE[i].x < minX)
      minX = FACE_ALIGN_TEMPLATE[i].x;
    if (FACE_ALIGN_TEMPLATE[i].x > maxX)
      maxX = FACE_ALIGN_TEMPLATE[i].x;
    if (FACE_ALIGN_TEMPLATE[i].y < minY)
      minY = FACE_ALIGN_TEMPLATE[i].y;
    if (FACE_ALIGN_TEMPLATE[i].y > maxY)
      maxY = FACE_ALIGN_TEMPLATE[i].y;
  }
  
  for (char i = 0; i < 68; i++) {
    FACE_ALIGN_TEMPLATE[i].x = (FACE_ALIGN_TEMPLATE[i].x - minX) / (maxX - minX);
    FACE_ALIGN_TEMPLATE[i].y = (FACE_ALIGN_TEMPLATE[i].y - minY) / (maxY - minY);
  }
  
  return self;
}

- (void) loadData {
  NSBundle* sdkBundle = [NSBundle bundleForClass:[self class]];
  NSString *dir = [sdkBundle resourcePath];
  const char *cpath = [dir fileSystemRepresentation];
  std::string homePath(cpath);
  dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
    //Background Thread
    dlib::deserialize(homePath + "/shape_predictor_68_face_landmarks.xml") >> faceShapePredictor;
    faceCascade.load(homePath + "/haarcascade_frontalface_alt.xml");
//    dispatch_async(dispatch_get_main_queue(), ^(void){
//      //Run UI Updates
//    });
  });

}
- (UIImage*) faceAlign: (UIImage*) inputImage : (Boolean) needToFindFace {
  cv::Mat matInputImage = [inputImage CVMat3];
  cv::Mat faceImg;
  if(needToFindFace)
    faceImg = faceAlign(matInputImage, faceShapePredictor, faceCascade, FACE_ALIGN_TEMPLATE);
  else
    faceImg = faceAlign(matInputImage, faceShapePredictor, faceCascade, FACE_ALIGN_TEMPLATE, cv::Rect(0, 0, matInputImage.cols, matInputImage.rows));
  return [UIImage UIImageFromCVMat: faceImg];
}

- (UIImage*) faceAlign: (UIImage*) inputImage {
  cv::Mat matInputImage = [inputImage CVMat3];
  cv::Mat faceImg = faceAlign(matInputImage, faceShapePredictor, faceCascade, FACE_ALIGN_TEMPLATE, cv::Rect(0, 0, matInputImage.cols, matInputImage.rows));
  return [UIImage UIImageFromCVMat: faceImg];
}
@end
