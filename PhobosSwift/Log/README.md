# Codebase Log for iOS

Codebase Log basic develop-kits for all the frameworks and apps.

## Installation

CodebaseLog is available through private [CocoaPods](https://cocoapods.org). To install
it, simply add the following lines to your Podfile:

Add source to your podfile
```
source 'https://github.com/CocoaPods/Specs.git'
source 'git@gitlab.porsche-preview.cn:porsche-digital-china/cscn/mobile-ios/codebase-spec.git'
```

Add pod to your podfile
```
pod 'CodebaseLog'
```


## Codebase Log Development

To access CodebaseLog via a checked out version of the codebase-ios-sdk repo do:

```
pod 'CodebaseLog', :path => '/path/to/codebase-ios-sdk', :testspecs => ['Tests']
```

## Codebase Log Release

We use fastlane as a tool to publish any new version of CodebaseCore, simple by following steps:
1. Go to the directory where your CodebaseLog.podspec listed
```
cd /path/to/codebase-ios-sdk
```

2. Release a new version of CodebaseLog pod
```
bundle exec fastlane ios release_pod --env Log
```

## Usage
```swift
let log = CodebaseLog(identifier: "BUName", level:.debug ) // different BU, different identifier please
log.enableFileLog = true // enable file log
log.enableEmoji = true // enable emoji symbols, Recommend
log.debug("some message") // main function, you can choose six levels listed bellow
log.debug("to file message",isToFile: true) // log some message to file,ignore the enableFileLog property
```
#which level to use
only levels equl or lower than CodebaseLog's level will be logged

EN
```
log.verbose("A verbose message, usually useful when working on a specific problem")
log.debug("A debug message")
log.info("An info message, probably useful to power users looking in console.app")
log.warning("A warning message, may indicate a possible error")
log.error("An error occurred, but it's recoverable, just info about what happened")
log.severe("A severe error occurred, we are likely about to crash now")
```
ZH
```
log.verbose("一条verbose级别消息：在处理特定问题时通常很有用。")
log.debug("一条debug级别消息：用于代码调试。")
log.info("一条info级别消息：常用与用户在console.app中查看。")
log.warning("一条warning级别消息：警告消息，表示一个可能的错误。")
log.error("一条error级别消息：表示产生了一个可恢复的错误，用于告知发生了什么事情。")
log.severe("一条severe error级别消息：表示产生了一个严重错误。程序可能很快会奔溃。")
```


## Author

Kraig Wu, iddkghost@gmail.com

## License

CodebaseLog is available under the MIT license. See the LICENSE file for more info.

