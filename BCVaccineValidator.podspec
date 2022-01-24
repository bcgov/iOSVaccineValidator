#
# Be sure to run `pod lib lint VaccineValidator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BCVaccineValidator'
  s.version          = '1.0.12'
  s.summary          = 'Validate vaccine cards allowed in British Columbia'
  s.license           = "Apache License, Version 2.0"

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/bcgov/iOSVaccineValidator'
  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'amirshayegh' => 'shayegh@me.com' }
  s.source           = { :git => 'https://github.com/bcgov/iOSVaccineValidator.git', :tag => s.version.to_s }
  s.platform          = :ios, "11.0"
  s.ios.deployment_target = '11.0'
  s.swift_version     = "5.0"
    

  s.source_files = 'BCVaccineValidator/Classes/**/*'
  
  s.resource_bundles = {
    'BCVaccineValidator' => ['BCVaccineValidator/Assets/*']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'Alamofire'
   s.dependency 'JOSESwift'
end
