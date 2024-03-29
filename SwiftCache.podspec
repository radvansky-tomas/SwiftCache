#
# Be sure to run `pod lib lint SwiftCache.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftCache'
  s.version          = '0.1.0'
  s.summary          = 'Basic caching library based on RealmDB'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Basic caching library based on RealmDB. It allows to cache any type of URL resource and
cache them separately based on MIME type inside Non-SQL database.
                       DESC

  s.homepage         = 'https://github.com/radvansky-tomas/SwiftCache'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tomas Radvansky' => 'radvansky.tomas@gmail.com' }
  s.source           = { :git => 'https://github.com/radvansky-tomas/SwiftCache.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'SwiftCache/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SwiftCache' => ['SwiftCache/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
    s.dependency 'Alamofire', '~> 4.0'
    s.dependency 'RealmSwift'
    s.dependency 'FCUUID'
end
