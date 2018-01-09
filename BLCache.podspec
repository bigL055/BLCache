Pod::Spec.new do |s|
s.name             = 'BLCache'
s.version          = '0.1.0'
s.summary          = '多种持久化集合'


s.homepage         = 'https://github.com/bigL055/Routable'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'linhey' => 'linhan.linhey@outlook.com' }
s.source = { :git => 'https://github.com/bigL055/BLCache.git', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'

s.source_files = ["Sources/*/**","Sources/*/*/**","Sources/**"]

s.public_header_files = ["Sources/BLCache.h"]

s.dependency 'YYCache'
s.dependency 'AnyFormatProtocol'

s.requires_arc = true
s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

end

