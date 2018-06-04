//
//  ViewController.swift
//  SFaceExample
//
//  Created by Bohdan Mihiliev on 6/4/18.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//

import UIKit
import SFaceCompare

final class ViewController: UIViewController {
  
  // MARK: - Outlets
  @IBOutlet weak private var firstImageView: UIImageView!
  @IBOutlet weak private var secondImageView: UIImageView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  // MARK: - Properties
  private var images = [UIImage]() {
    didSet {
      if images.count == 2 {
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: .background).async {
          CVUtilsInterface.areSameFaces(on: self.images[0], and: self.images[1], facesFound: true)
          DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
          }
        }
      }
    }
  }
  private var selectedImageViewTag = 0
  
  // MARK: - Lifecycle events
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let firstImageViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.connected(_:)))
    let secondImageViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.connected(_:)))
    
    firstImageView.addGestureRecognizer(firstImageViewTapGestureRecognizer)
    secondImageView.addGestureRecognizer(secondImageViewTapGestureRecognizer)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
    if motion == .motionShake  {
      print("Did Shake")
      images.removeAll()
      firstImageView.image = #imageLiteral(resourceName: "empty-image")
      secondImageView.image = #imageLiteral(resourceName: "empty-image")
      firstImageView.isUserInteractionEnabled = true
      UIView.animate(withDuration: 0.35, animations: {
        self.secondImageView.alpha = 0.1
      })
    }
  }
  
  // MARK: - Actions
  @objc func connected( _ sender:AnyObject) {
    selectedImageViewTag = sender.view.tag
    presentImagePicker()
  }
  
}

// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : Any]) {
    
    if let selectedPhoto = info[UIImagePickerControllerOriginalImage] as? UIImage {
      dismiss(animated: true, completion: { [unowned self] in
        self.images.append(selectedPhoto)
        switch self.selectedImageViewTag {
        case 0:
          self.firstImageView.image = selectedPhoto
          self.secondImageView.isUserInteractionEnabled = true
          self.firstImageView.isUserInteractionEnabled = false
          UIView.animate(withDuration: 0.35, animations: {
            self.secondImageView.alpha = 1
          })
        case 1:
          self.secondImageView.image = selectedPhoto
          self.secondImageView.isUserInteractionEnabled = false
        default:
          fatalError("Unexpected behaviour")
        }
      })
    }
    
  }
  
  func presentImagePicker() {
    let imagePickerActionSheet = UIAlertController(title: "Snap/Upload Image",
                                                   message: nil, preferredStyle: .actionSheet)
    
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      let cameraButton = UIAlertAction(title: "Take Photo",
                                       style: .default) { (alert) -> Void in
                                        let imagePicker = UIImagePickerController()
                                        imagePicker.delegate = self
                                        imagePicker.sourceType = .camera
                                        self.present(imagePicker, animated: true)
      }
      imagePickerActionSheet.addAction(cameraButton)
    }
    
    let libraryButton = UIAlertAction(title: "Choose Existing",
                                      style: .default) { (alert) -> Void in
                                        let imagePicker = UIImagePickerController()
                                        imagePicker.delegate = self
                                        imagePicker.sourceType = .photoLibrary
                                        self.present(imagePicker, animated: true)
    }
    imagePickerActionSheet.addAction(libraryButton)
    let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
    imagePickerActionSheet.addAction(cancelButton)
    present(imagePickerActionSheet, animated: true)
  }
  
}

// MARK: - UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {
  
}
