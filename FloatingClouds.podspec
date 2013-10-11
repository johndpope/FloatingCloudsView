Pod::Spec.new do |s|
  s.name     = 'FloatingClouds'
  s.version  = '0.1'
  s.author   = { 'satgi' => 'sanntgi@gmail.com' }
  s.homepage = 'http://106.187.98.195/satgi/floatingclouds'
  s.summary  = 'A collection view of labels with random animation, like the floating clouds.'
  s.license  = 'MIT'
  s.source   = { :git => 'http://106.187.98.195/root/floatingclouds.git', :tag => '0.1' }
  s.source_files = 'FloatingClouds/FloatingCloudsView'
  s.platform = :ios
  s.ios.deployment_target = '6.0'
  s.requires_arc = true
end