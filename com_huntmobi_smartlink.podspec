Pod::Spec.new do |spec|
  spec.name         = "com_huntmobi_smartlink"
  spec.version      = "0.1.1"
  spec.summary      = "smartlink"
  spec.description  = <<-DESC
    smartlink
  DESC
  spec.homepage     = "https://github.com/web2app-bi4sight/smartlink-iOS"
  spec.license      = "MIT"
  spec.author       = { "Leo" => "leoliu@huntmobi.com" }                   
  spec.platform     = :ios
  spec.ios.deployment_target = "12.0"
  spec.source       = { :git => "https://github.com/web2app-bi4sight/smartlink-iOS.git", :tag => "#{spec.version}" }
  spec.source_files  = "com_huntmobi_smartlink/*.{h,m}"
  spec.public_header_files = "com_huntmobi_smartlink/*.h"
  spec.requires_arc = true
end
