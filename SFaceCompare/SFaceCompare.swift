//
//  SFaceCompare.swift
//  SFaceCompare
//
//  Created by Soft Project on 6/5/18.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//

import PrivateOpenCVModule
import Vision

public class SFaceCompare {

  public static let opncvwrp: OpenCVWrapper = OpenCVWrapper()
  private let operationQueue: OperationQueue
  let firstImage: UIImage
  let secondImage: UIImage
  
  public init(on firstImage: UIImage, and secondImage: UIImage ){
    self.firstImage = firstImage
    self.secondImage = secondImage
    self.operationQueue = OperationQueue()
    self.operationQueue.qualityOfService = .background
    //    self.opncvwrp = OpenCVWrapper()
  }
  
  /**
   Compares faces from the two input image.
   
   - parameter firstImage: Image with first face to compare.
   - parameter secondImage: Image with second face to compare.
   
   - returns: True if faces are same and false if they are not.
   */
  public func compareFaces(succes: @escaping ([DetectionResult])->(), failure: @escaping (Error) -> () ) { //  func areSameFaces(on firstImage: UIImage, and secondImage: UIImage) {
    
    guard let firstFaceDetectionOperation = FaceDetectionOperation(input: firstImage, objectsCountToDetect: 1,
                                                                   orientation: CGImagePropertyOrientation.up) else {
                                                                    Logger.e("Can not instantiate face detection for photoOfDidinaID of type UIImage")
                                                                    return //false
    }
    
    guard let secondFaceDetectionOperation = FaceDetectionOperation(input: secondImage, objectsCountToDetect: 1,
                                                                    orientation: CGImagePropertyOrientation.up) else {
                                                                      Logger.e("Can not instantiate face detection for photoOfDidinaID of type UIImage")
                                                                      return //false
    }
    
    // Creating final operation
    let finishOperation = BlockOperation {
      // Checking results from firstFaceDetectionOperation
      guard let firstFaceOperationResults = firstFaceDetectionOperation.operationResult?.first else {
        DispatchQueue.main.async {
          let error = SFaceError.emptyResultsIn("Face detection Operation", reason: nil)
          failure(error)
        }
        return
      }
      
      // Checking results from secondFaceDetectionOperation
      guard let secondFaceOperationResults = secondFaceDetectionOperation.operationResult?.first else {
        DispatchQueue.main.async {
          let error = SFaceError.emptyResultsIn("Face detection Operation", reason: nil)
          failure(error)
        }
        return
      }
      
      // Processing results from operations
      /*
       1. Get aligned faces
       2. Pass them through ML model
       3. Return results
       */
      guard let firstAlignedFace = SFaceCompare.opncvwrp.faceAlign(firstFaceOperationResults.image),
        let secondAlignedFace = SFaceCompare.opncvwrp.faceAlign(secondFaceOperationResults.image) else {
          DispatchQueue.main.async {
            let error = SFaceError.wrongFaces(reason: "Faces can not be aligned. Try other images")
            failure(error)
          }
          return
      }
      do {
        let net = OpenFace()
        guard let firstPixelBuffer = firstAlignedFace.cvPixelBuffer,
          let secondPixelBuffer = secondAlignedFace.cvPixelBuffer else {
            DispatchQueue.main.async {
              let error = SFaceError.wrongFaces(reason: "Can not extract cvPixelBuffer to one of image. Try other images.")
              failure(error)
            }
            return
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
        //        return result < 1.0
        if result < 1.0 {
          DispatchQueue.main.async {
            succes([firstFaceOperationResults, secondFaceOperationResults])
          }
        } else {
          DispatchQueue.main.async {
            let error = SFaceError.wrongFaces(reason: "Faces are not the same. Matching coof is \(result)")
            failure(error)
          }
        }
      } catch {
        Logger.e(error.localizedDescription)
        DispatchQueue.main.async {
          failure(error)
        }
      }
    }
    
    // Adding operations and dependencies
    finishOperation.addDependency(firstFaceDetectionOperation)
    finishOperation.addDependency(secondFaceDetectionOperation)
    
    operationQueue.addOperations([firstFaceDetectionOperation,
                                       secondFaceDetectionOperation,
                                       finishOperation], waitUntilFinished: false)
  }
  
  deinit {
    Logger.i("Deinited")
  }
  //  func detect(facesCount: Int, on image: UIImage) {
  //
  //    let recognitionRequest = VNDetectFaceRectanglesRequest { request, error in
  //      if let error = error {
  //        Logger.e("\(error.localizedDescription)")
  //        return
  //      }
  //
  //      guard let results = request.results as? [VNFaceObservation] else {
  //        fatalError("Unexpected result type from VNDetectFaceRectanglesRequest")
  //      }
  //
  ////      // Need check results only if objectsCountToDetect isn't default
  ////      if facesCount != 0 {
  ////        guard results.count == objectsCountToDetect else {
  ////          Logger.e("Wrong Face Results count: Founded - \(results.count) | Required - \(facesCount)")
  ////          return
  ////        }
  ////      }
  //      let cGAffineTransform = CGAffineTransform.identity
  //        .scaledBy(x: image.size.width, y: -image.size.height)
  //        .translatedBy(x: 0, y: -1)
  //
  //      let detectedFaces = results
  //        .lazy
  //        .map { $0.boundingBox.applying(cGAffineTransform) }
  //        .compactMap {  rect -> DetectionResult? in
  //          guard let detectedFaceCIImage = image
  //            .cgImage?
  //            .cropping(to: rect) else { return nil }
  //          return DetectionResult(image: UIImage(cgImage: detectedFaceCIImage),
  //                                 rect: rect)
  //      }
  //    }
  //
  //    guard let cgImageToProcess = image.cgImage else {
  //      Logger.e("Can not Extract CGImage from UIImage")
  //      return
  //    }
  //
  //    let vNImageRequestHandler = VNImageRequestHandler(cgImage: cgImageToProcess, options: [:])
  //    do {
  //      try vNImageRequestHandler.perform([recognitionRequest])
  //    } catch {
  //      Logger.e(error.localizedDescription)
  //    }
  //  }
}
