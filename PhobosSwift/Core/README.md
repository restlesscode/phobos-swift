# Codebase Core for iOS

Codebase Core basic develop-kits for all the frameworks and apps.

## Installation

CodebaseCore is available through private [CocoaPods](https://cocoapods.org). To install
it, simply add the following lines to your Podfile:

Add source to your podfile
```
source 'https://github.com/CocoaPods/Specs.git'
source 'git@gitlab.porsche-preview.cn:porsche-digital-china/cscn/mobile-ios/codebase-spec.git'
```

Add pod to your podfile
```
pod 'CodebaseCore'
```


## Codebase Core Development

To access CodebaseCore via a checked out version of the codebase-ios-sdk repo do:

```
pod 'CodebaseCore', :path => '/path/to/codebase-ios-sdk'
```

## Codebase Core Release

We use fastlane as a tool to publish any new version of CodebaseCore, simple by following steps:
1. Go to the directory where your CodebaseCore.podspec listed
```
cd /path/to/codebase-ios-sdk
```

2. Release a new version of CodebaseCore pod
```
bundle exec fastlane ios release_pod --env Core
```

## Usage

## Author

Theo Chen, me@theochen.com

## License

CodebaseCore is available under the MIT license. See the LICENSE file for more info.
