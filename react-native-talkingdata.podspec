require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = 'react-native-talkingdata'
  s.version      = package['version']
  s.summary      = package['description']
  s.license      = package['license']

  s.authors      = package['author']
  s.homepage     = package['homepage']
  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/cross2d/react-native-talkingdata.git", :tag => "v#{s.version}" }
  s.source_files  = "ios/**/*.{h,m}"
  s.libraries =  "z"
  s.preserve_paths = "libTalkingData.a"
  s.frameworks = [
      "AdSupport",
      "CoreMotion",
      "CoreTelephony",
      "SystemConfiguration"
  ]
  s.dependency 'React'
end
