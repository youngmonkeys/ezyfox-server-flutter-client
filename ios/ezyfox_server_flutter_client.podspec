#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint ezyfox_server_flutter_client.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'ezyfox_server_flutter_client'
  s.version          = '0.0.1'
  s.summary          = 'EzyFox Server's Flutter client sdk.'
  s.description      = <<-DESC
EzyFox Server's Flutter client sdk.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'youngmonkeys.org' => 'https://youngmonkeys.org' }
  s.source           = { :path => '.' }
  s.source_files = 'EzyClient/**/*'
  s.public_header_files = 'EzyClient/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
