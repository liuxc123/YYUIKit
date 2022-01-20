Pod::Spec.new do |s|
    s.name             = 'YYUIKit'
    s.version          = '1.0.2'
    s.summary      = "A collection of stand-alone production-ready UI libraries focused on design details."
    s.homepage         = 'https://github.com/liuxc123/YYUIKit'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'liuxc123' => 'lxc_work@126.com' }
    s.source           = { :git => 'https://github.com/liuxc123/YYUIKit.git', :tag => s.version.to_s }
    s.platform     = :ios
    s.requires_arc = true
    s.ios.deployment_target = '10.0'
    s.source_files = 'YYUIKit/**/*.{h,m}'
    s.public_header_files = 'YYUIKit/**/*.{h}'
    s.resource_bundles = {"YYUIKit" => ["YYUIKit/Resource/*.*"]}
    s.dependency "YYKit"
    
end
