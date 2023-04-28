# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

plugin 'cocoapods-binary-cache'

config_cocoapods_binary_cache(
  cache_repo: {
    "default" => {
      "remote" => "git@cache_repo.git",
      "local" => "~/.cocoapods-binary-cache/prebuilt-frameworks"
    }
  },
  prebuild_config: "Debug"
)

target 'MenuMonya' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'NMapsMap', :binary => true
  # Add the Firebase pod for Google Analytics
  pod 'FirebaseAnalytics', :binary => true
  pod 'Firebase/Crashlytics', :binary => true

  # Add the pods for any other Firebase products you want to use in your app
  # For example, to use Firebase Authentication and Cloud Firestore
  pod 'FirebaseFirestore', :binary => true
  pod 'FirebaseFirestoreSwift', :binary => true

  # Pods for MenuMonya

  target 'MenuMonyaTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MenuMonyaUITests' do
    # Pods for testing
  end

end
