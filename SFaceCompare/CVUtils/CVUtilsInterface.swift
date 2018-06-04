//
//  CVUtilsInterface.swift
//  SFaceCompare
//
//  Created by Anton Khrolenko on 5/31/18.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//

import PrivateOpenCVModule

public struct CVUtilsInterface {
  
  static let opncvwrp = OpenCVWrapper()
  /**
   Compares faces from the two input image.
   
   - parameter firstImage: Image with first face to compare.
   - parameter secondImage: Image with second face to compare.
   - parameter facesFound: Indicates necessity of searching for a face on the images. If false - function will find faces by itself.
   
   - returns: True if faces are same and false if they are not.
   */
  public static func areSameFaces(on firstImage: UIImage,
                                  and secondImage: UIImage,
                                  facesFound: Bool) -> Bool {
    guard let firstAlignedFace = opncvwrp.faceAlign(firstImage, facesFound),
      let secondAlignedFace = opncvwrp.faceAlign(secondImage, facesFound) else {
         return false
    }
    do {
      let net = OpenFace()
      guard let firstPixelBuffer = firstAlignedFace.cvPixelBuffer,
        let secondPixelBuffer = secondAlignedFace.cvPixelBuffer else {
          return false
      }
      // neural networks answers getting
      let firstOutput = try net.prediction(data: firstPixelBuffer).output
      let secondOutput = try net.prediction(data: secondPixelBuffer).output
      var result = 0.0
      
      // network outputs differece calculating
      for idx in 0..<128 {
        result += (Double(truncating: firstOutput[idx]) - Double(truncating: secondOutput[idx]))
          * (Double(truncating: firstOutput[idx]) - Double(truncating: secondOutput[idx]))
      }
      print(result)
      return result < 1.0
    } catch {
      Logger.e(error.localizedDescription)
      return false
    }
  }
}
