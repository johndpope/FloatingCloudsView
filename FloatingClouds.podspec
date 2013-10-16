Pod::Spec.new do |s|
  s.name     = 'FloatingClouds'
  s.version  = '0.1.1'
  s.author   = { 'satgi' => 'sanntgi@gmail.com' }
  s.homepage = 'https://github.com/satgi/FloatingCloudsView.git'
  s.summary  = 'A collection view of labels with random animation, like the floating clouds.'
  s.license  = 'MIT'
  s.source   = { :git => 'https://github.com/satgi/FloatingCloudsView.git', :tag => '0.1.1' }
  s.source_files = 'FloatingClouds/FloatingCloudsView'
  s.platform = :ios
  s.ios.deployment_target = '6.0'
  s.frameworks = 'QuartzCore'
  s.requires_arc = true
end