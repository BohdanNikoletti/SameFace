//
//  AppDelegate.swift
//  SFaceExample
//
//  Created by Bohdan Mihiliev on 6/4/18.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//

import UIKit
import SameFace

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    SFaceCompare.opncvwrp.loadData()
    return true
  }
}

