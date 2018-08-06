# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'PetMatched' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'Alamofire', '~> 4.6'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'HexColors', '~> 6.0'
  pod 'SwiftMessages', '~> 4.1'
  pod 'SDWebImage', '~> 4.3'
  pod 'SkyFloatingLabelTextField', '~> 3.5.1'
  pod 'PopupDialog', '~> 0.7'
  pod 'SBPickerSelector', '~> 1.2'
  pod 'Cloudinary', '~> 2.3'
  pod 'AlignedCollectionViewFlowLayout', '~> 1.1.1'
  pod 'Koloda', '~> 4.3'
  pod 'DPMeterView', '~> 1.0'
  pod 'IQKeyboardManagerSwift', '~> 6.0.0'
  pod 'GrowingTextView', '~> 0.5'
  pod 'MXSegmentedPager', '~> 3.3'
  pod 'UIViewController+KeyboardAnimation', '~> 1.3'
  pod 'SwipeCellKit', '~> 2.4.3'

  target 'PetMatchedTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PetMatchedUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
