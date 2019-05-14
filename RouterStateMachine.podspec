#
# Be sure to run `pod lib lint RouterStateMachine.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RouterStateMachine'
  s.version          = '0.2.2'
  s.summary          = 'A short description of RouterStateMachine.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  The class that represents StateMachine patternt for Routers objects that are used in the concept of
  UseCases/Viper/Clean Architechture
                       DESC

  s.homepage         = 'https://github.com/aldo-dev/RouterStateMachine'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ALDO Inc.' => 'aldodev@aldogroup.com' }
  s.source           = { :git => 'https://github.com/aldo-dev/RouterStateMachine.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'
  s.source_files = 'RouterStateMachine/Classes/**/*'

   s.dependency 'SwiftyCollection'
end
