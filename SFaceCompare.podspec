Pod::Spec.new do |s|
  s.platform = :ios
  s.ios.deployment_target = '11.3'
  s.name = "SFaceCompare"
  s.summary = "Simple lib fro iOS to find and compare faces."
  s.requires_arc = true
  s.version = "1.0.0"
  s.description  = <<-DESC
  SFaceCompare is an simple libray for iOS to find and compare faces. SFaceCompare works on top of dlib and OpenCV libraries.
  With usage of trained model.
                   DESC

  s.homepage     = "https://github.com/BohdanNikoletti/SFaceCompare"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.authors = { 'Bohdan Mihiliev' => 'bohdanrose1@gmail.com',
                   'Anton Khrolenko' => 'hobdag@gmail.com'}
  s.source       = { :git => "https://github.com/BohdanNikoletti/SFaceCompare.git", :tag => "#{s.version}" }
  s.ios.frameworks = 'UIKit', 'CoreImage', 'Accelerate'
  s.dependency 'OpenCV'
  s.static_framework = true
  s.swift_version = '4.0'
  s.source_files = 'SFaceCompare/**/*.swift'
  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(PROJECT_DIR)/lib',
    'SWIFT_INCLUDE_PATHS' => '$(SRCROOT)/SFaceCompare/CVUtils',
  'SWIFT_VERSION': '4.0' }
  s.preserve_paths = 'SFaceCompare/CVUtils/module.modulemap'
end
