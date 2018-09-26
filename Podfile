source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

use_frameworks!

target 'PromptRating' do

end

target 'PromptRatingExample' do
    
end

target 'PromptRatingTests' do

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3'
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end
