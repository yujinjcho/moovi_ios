source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
inhibit_all_warnings!
use_frameworks!

target 'MovieRec' do
    pod 'RxSwift', '~> 3.2'
    pod 'RxCocoa', '~> 3.2'
    pod 'Kingfisher', '~> 3.0'
    pod 'SwiftyJSON', '~> 3.1'
    
    target "MovieRecTests" do
        inherit! :search_paths
        pod 'Nimble', '~> 6.1'
        pod 'Quick', '~> 1.1'
        pod 'RxBlocking', '~> 3.0'
        pod 'RxTest', '~> 3.0'
    end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
    end
end
