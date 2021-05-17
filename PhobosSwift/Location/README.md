# CodebaseUI Core for iOS

CodebaseUI Core is basic UI-related develop-kits for all the frameworks and apps.

## Installation

CodebaseUICore is available through private [CocoaPods](https://cocoapods.org). To install
it, simply add the following lines to your Podfile:

Add source to your podfile
```
source 'https://github.com/CocoaPods/Specs.git'
source 'git@gitlab.porsche-preview.cn:porsche-digital-china/cscn/mobile-ios/codebase-spec.git'
```

Add pod to your podfile
```
pod 'CodebaseUICore'
```


## CodebaseUI Core Development

To access CodebaseUICore via a checked out version of the codebaseui-ios repo do:

```
pod 'CodebaseUICore', :path => '/path/to/codebaseui-ios'
```

## CodebaseUICore Release

We use fastlane as a tool to publish any new version of CodebaseUICore, simple by following steps:
1. Go to the directory where your CodebaseUICore.podspec listed
```
cd /path/to/codebaseui-ios
```

2. Release a new version of CodebaseUICore pod
```
bundle exec fastlane ios release_pod --env Core
```

## Usage

## Author

Theo Chen, me@theochen.com

## License

CodebaseUICore is available under the MIT license. See the LICENSE file for more info.
