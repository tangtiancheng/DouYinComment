

Pod::Spec.new do |spec|

  spec.name         = "TTCTool"
  spec.version      = "0.0.1"
  spec.summary      = "TTCTool."
  spec.description  = <<-DESC
    TTCTool.TTCTool.TTCTool.TTCTool.
                   DESC
  spec.homepage     = "https://github.com/tangtiancheng/DouYinComment"
  spec.license      = "MIT"
  spec.author             = { "tangtiancheng" => "1262711517@qq.com" }
  spec.source       = { :git => "https://github.com/tangtiancheng/DouYinComment.git", :tag => "#{spec.version}" }
  spec.source_files  = "DouYinCComment/TTCTool/ViewPage/TCViewPage(你只需要以下两个类即可实现分页和嵌套滚动)/**/*.{h,m}"
 
  spec.ios.deployment_target = '9.0'

end
