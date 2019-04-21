Pod::Spec.new do |s|
  s.name             = 'ASNavigationBarKit'
  s.version          = '0.1.0'
  s.summary          = 'Texture NavigationBar Kit'

  s.description      = 'iOS NavigationBar Kit built on Texture. smooth, responsive & easy to maintain'

  s.homepage         = 'https://github.com/Geektree0101/ASNavigationBarKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Geektree0101' => 'h2s1880@gmail.com' }
  s.source           = { :git => 'https://github.com/Geektree0101/ASNavigationBarKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'ASNavigationBarKit/Classes/**/*'
  s.dependency 'Texture', '~> 2.7'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
end
