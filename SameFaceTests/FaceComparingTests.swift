//
//  SFaceCompareTests.swift
//  SFaceCompareTests
//
//  Created by Bohdan Mihiliev on 26.05.2018.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//

import XCTest
@testable import SameFace

struct ImagesResources {
  private static let bundle = Bundle(for: FaceComparingTests.self)
  private init() { }
  static let normalFemaleFace = UIImage(named: "NormalFemaleFace", in: bundle, compatibleWith: nil)
  static let normalMaleFace = UIImage(named: "NormalMaleFace", in: bundle, compatibleWith: nil)
  static let christoferNolanFace = UIImage(named: "ChristopherNolan", in: bundle, compatibleWith: nil)
  static let christoferNolanFace2 = UIImage(named: "ChristopherNolan2", in: bundle, compatibleWith: nil)
  static let michaelBayFace = UIImage(named: "MichaelBay", in: bundle, compatibleWith: nil)
  static let michaelBayFace2 = UIImage(named: "MichaelBay2", in: bundle, compatibleWith: nil)
  
}

final class FaceComparingTests: XCTestCase {
  
  // AMRK: - Properties

  // MARK: - Lifecycle events
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  // MARK: - Test cases
  func testDifferentFaces() {
    self.measure {
      let operationResults = CVUtilsInterface.areSameFaces(on: getFace(from: ImagesResources.normalFemaleFace!)!,
                                                           and: getFace(from: ImagesResources.normalMaleFace!)!,
                                                           facesFound: true)
      XCTAssertFalse(operationResults, "Face are the same")
      
    }
  
  }
  
  func testSameImagesFaces() {
    XCTAssertTrue(CVUtilsInterface.areSameFaces(on: getFace(from: ImagesResources.normalFemaleFace!)!,
                                                 and: getFace(from: ImagesResources.normalFemaleFace!)!,
                                                 facesFound: true), "Female faces are not the same")
    
    XCTAssertTrue(CVUtilsInterface.areSameFaces(on: getFace(from: ImagesResources.normalMaleFace!)!,
                                                and: getFace(from:ImagesResources.normalMaleFace!)!,
                                                facesFound: true), "Male faces are not the same")
  }
  
  func testChristoferNolanFaces() {
    XCTAssertTrue(CVUtilsInterface.areSameFaces(on: getFace(from: ImagesResources.christoferNolanFace!)!,
                                                and: getFace(from: ImagesResources.christoferNolanFace2!)!,
                                                facesFound: true), "Christofer Nolan faces are not the same")
  }
  
  func testMichaelBayFaces() {
    XCTAssertTrue(CVUtilsInterface.areSameFaces(on: getFace(from: ImagesResources.michaelBayFace!)!,
                                                and: getFace(from: ImagesResources.michaelBayFace2!)!,
                                                facesFound: true), "Michael Bay faces are not the same")
  }
  
  func testCompareBayAndNolanFaces() {
    XCTAssertFalse(CVUtilsInterface.areSameFaces(on: getFace(from: ImagesResources.christoferNolanFace2!)!,
                                                and: getFace(from: ImagesResources.michaelBayFace2!)!,
                                                facesFound: true), "Michael Bay face and Christofer NolanFace are the same")
  }
  
  // MARK: - Private methods
  private func getFace(from image: UIImage) -> UIImage? {
    
    guard let faceDetectionOperation = FaceDetectionOperation(input: image, objectsCountToDetect: 1,
                                                              orientation: CGImagePropertyOrientation.up) else {
                                                                XCTFail("Can not instantiate face detection for photoOfDidinaID of type UIImage")
                                                                return nil
    }
    
    faceDetectionOperation.main()
    guard let results = faceDetectionOperation.operationResult else {
      XCTFail("Face detection results is nil")
      return nil
    }
    
    guard let face = results.first?.image else {
      XCTFail("Face doe not detected")
      return nil
    }
    return face
  }
}
