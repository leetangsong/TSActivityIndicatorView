
Pod::Spec.new do |s|
  s.name             = 'TSActivityIndicatorView'
  s.version          = '0.1.0'
  s.summary          = 'A short description of TSActivityIndicatorView.'


  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/leetangsong/TSActivityIndicatorView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'leetangsong' => 'leetangsong@icloud.com' }
  s.source           = { :git => 'https://github.com/leetangsong/TSActivityIndicatorView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  s.swift_versions         = ['5.0']

  s.source_files = 'Source/TSActivityIndicatorView/**/*'
  
  s.subspec 'Animations' do |animations|
        animations.source_files   = "Sources/TSActivityIndicatorView/Animations/**/*"
  end
  
  # s.resource_bundles = {
  #   'TSActivityIndicatorView' => ['TSActivityIndicatorView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
