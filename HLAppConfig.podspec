Pod::Spec.new do |s|
  s.name             = "HLAppConfig"
  s.version          = "0.0.1"
  s.summary          = "A App Online Config used on iOS."
  s.description      = <<-DESC
                       It is a app online config used on iOS, which implement by Objective-C.
                       DESC
  s.homepage         = "https://github.com/LingyeHan/HLAppConfig"
  # s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "HanLingye" => "lingye.han@gmail.com" }
  s.source           = { :git => "https://github.com/LingyeHan/HLAppConfig.git", :tag => s.version }
  # s.social_media_url = 'https://twitter.com/NAME'

  s.platform     = :ios, '8.0'
  # s.ios.deployment_target = '8.0'
  # s.osx.deployment_target = '10.9'
  s.requires_arc = true

  s.source_files = 'HLAppConfig/HLAppConfig/*'
  # s.resources = 'Assets'

  # s.ios.exclude_files = 'Classes/osx'
  # s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'Foundation', 'UIKit'

end
