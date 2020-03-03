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
  s.preserve_paths = "ios/TalkingDataSDK/libTalkingData.a"
  s.vendored_libraries = "ios/TalkingDataSDK/libTalkingData.a"

  s.pod_target_xcconfig = {
    "FRAMEWORK_SEARCH_PATHS" => '$(inherited) $(SRCROOT)/../../node_modules/@cross2d/react-native-talkingdata/ios/TalkingDataSDK/',
    "LIBRARY_SEARCH_PATHS" => '$(inherited) $(SRCROOT)/../../node_modules/@cross2d/react-native-talkingdata/ios/TalkingDataSDK/'
  }

# 问题：
# 查看详细信息：pod lib lint --verbose
# pod lib lint 验证不通过，App normal i386和App normal x86_64。不支持i386和x86_64编译，即不能在模拟器下编译。
# 解决：添加spec.pod_target_xcconfig。
# 参考： https://www.jianshu.com/p/88180b4d2ab7/
# 执行命令跳过模拟器验证：pod lib lint --skip-import-validation
#  s.pod_target_xcconfig = { 'VALID_ARCHS[sdk=iphonesimulator*]' => '' }

  s.frameworks = [
      "AdSupport",
      "CoreMotion",
      "CoreTelephony",
      "SystemConfiguration"
  ]
  s.dependency 'React'
end
