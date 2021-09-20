#
# Be sure to run `pod lib lint PhobosObjC.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

group = "PhobosSwift"
name = "CocoaPods"
pod_name = "#{group}"

has_public_header_files = false
has_resource_bundles = false
has_preserve_paths = false
enable_test = true


Pod::Spec.new do |s|
  s.name             = "#{pod_name}"
  s.version          = '0.1.0'
  s.summary          = "#{pod_name} is a basic develop-kits for all the frameworks and apps."
  s.swift_version    = '5.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/restlesscode/phobos-objc'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Restless Developer' => 'developer@codebase.codes' }
  s.source           = { :git => 'https://github.com/restlesscode/phobos-objc.git', :tag => "#{name}-" + s.version.to_s }
  s.social_media_url = 'https://twitter.com/CodesRestless'

  s.ios.deployment_target = '11.0'

  s.cocoapods_version = '>= 1.10.0'
  s.static_framework = false
  s.prefix_header_file = false

  if has_preserve_paths
    s.preserve_paths = [
      "#{group}/#{name}/README.md",
      "#{group}/#{name}/CHANGELOG.md"
    ]
  end

  s.default_subspec = 'Core'

  s.subspec 'Log' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.dependency "#{group}Log", '~> 0.1.1'
  end
  
  s.subspec 'Core' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.dependency "#{group}Core", '~> 0.1.1'
  end

  s.subspec 'Animation' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.dependency "#{group}Animation", '~> 0.1.1'
  end

  s.subspec 'Auth' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.dependency "#{group}Auth", '~> 0.1.1'
  end

  s.subspec 'Location' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.dependency "#{group}Location", '~> 0.1.1'
  end

  s.subspec 'Media' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.dependency "#{group}Media", '~> 0.1.1'
  end

  s.subspec 'Network' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.dependency "#{group}Network", '~> 0.1.1'
  end

  s.subspec 'Persistence' do |ss|
    ss.ios.deployment_target = '11.0'
    ss.dependency "#{group}Persistence", '~> 0.1.1'
  end

  s.subspec 'Push' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.dependency "#{group}Push", '~> 0.1.1'
  end

  s.subspec 'Router' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.dependency "#{group}Router", '~> 0.1.1'
  end

  s.subspec 'Slideout' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.dependency "#{group}Slideout", '~> 0.1.1'
  end

  s.subspec 'Splash' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.dependency "#{group}Splash", '~> 0.1.1'
  end

  s.subspec 'TestKnight' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.dependency "#{group}TestKnight", '~> 0.1.1'
  end

  s.subspec 'UIComponent' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.dependency "#{group}UIComponent", '~> 0.1.1'
  end
  
end
