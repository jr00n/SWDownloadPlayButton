#
# Be sure to run `pod lib lint SWDownloadPlayButton.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SWDownloadPlayButton'
  s.version          = '0.1.0'
  s.summary          = 'A customizable download and play button for downlaoding before playing a file'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A Fork of the nice customizable AHDownloadButton. I needed more states and no text buttons but only icons.
                       DESC

  s.homepage         = 'https://github.com/jr00n/SWDownloadPlayButton'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jr00n' => 'jeroen.wolff@gmail.com' }
  s.source           = { :git => 'https://github.com/jr00n/SWDownloadPlayButton.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/jr00n'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SWDownloadPlayButton/Classes/**/*'
  
  s.resource_bundles = {
     'SWDownloadPlayButton' => ['SWDownloadPlayButton/Assets/Assets.xcassets']
  }

  s.frameworks = 'UIKit'
  s.swift_version = '4.2'
end
