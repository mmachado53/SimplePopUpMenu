#
# Be sure to run `pod lib lint SimplePopUpMenu.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SimplePopUpMenu'
  s.version          = '0.1.0'
  s.summary          = 'Simple but customizable popup menu in swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Simple but customizable popup menu in swift, can change colors and icons.
                       DESC

  s.homepage         = 'https://github.com/mmachado53/SimplePopUpMenu'
  s.screenshots     = 'https://raw.githubusercontent.com/mmachado53/SimplePopUpMenu/develop/readmefiles/demo-popup.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mmachado53' => 'mmachado53@gmail.com' }
  s.source           = { :git => 'https://github.com/mmachado53/SimplePopUpMenu.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.3'
  s.swift_versions = '4.0'

  s.source_files = 'SimplePopUpMenu/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SimplePopUpMenu' => ['SimplePopUpMenu/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
