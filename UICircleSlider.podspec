Pod::Spec.new do |s|
  s.name         = "UICircleSlider"
  s.version      = "1.0.1"
  s.summary      = "A Circle style Slider like UISlider."

  s.description  = <<-DESC
                    A Circle style Slider like UISlider. Can be use as Circle style UIProgressView with User Interaction Disabled.
                   DESC

  s.homepage     = "https://github.com/kidyoungx/UICircleSlider"

  s.license      = "MPL-2.0"

  s.author             = { "Kid Young" => "kidyoungx@gmail.com" }

  s.platform     = :ios
  s.ios.deployment_target = "5.0"

  s.source       = { :git => "https://github.com/kidyoungx/UICircleSlider.git", :tag => s.version }

  s.source_files  = "UICircleSlider", "UICircleSlider/**/*.{h,m}"
  s.exclude_files = "Sample"

  s.public_header_files = "UICircleSlider/**/*.h"

  s.framework = "UIKit"

  s.requires_arc = true

end
