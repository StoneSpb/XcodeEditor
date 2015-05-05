Pod::Spec.new do |s|
  s.name     = 'XcodeEditor'
  s.version  = '2.0.0'
  s.license  = 'Apache2.0'
  s.summary  = 'An API for manipulating Xcode Projects using objective-C.'
  s.homepage = 'https://github.com/StoneSpb/XcodeEditor'
  s.author   = { 'Jasper Blues' => 'jasper@appsquick.ly' }
  s.source   = { :git => 'https://github.com/StoneSpb/XcodeEditor.git', :tag => 'v2.0.0' }
  s.platform = :osx
  s.source_files = 'Source/*.{h,m}', 'Source/Utils/*.{h,m}'
  s.requires_arc = true
  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
end
