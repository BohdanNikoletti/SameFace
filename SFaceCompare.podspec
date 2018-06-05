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
  spec.authors = { 'Bohdan Mihiliev' => 'bohdanrose1@gmail.com',
                   'Anton Khrolenko' }
  s.social_media_url   = "http://geekowl.com.ua/SFaceCompare"
  s.source       = { :git => "https://github.com/BohdanNikoletti/SFaceCompare.git", :tag => "#{s.version}" }
  s.ios.frameworks = 'UIKit', 'CoreImage', 'Accelerate'
  s.dependency 'OpenCV'
  s.source_files = "SFaceCompare/**/*.{swift}"
  s.exclude_files = "Classes/Exclude"
  s.resources = "SFaceCompare/**/*.{png,jpeg,jpg,storyboard,xib}"

end
