//
//  SKMesurement.swift
//  SKPhotoBrowser
//
//  Created by 鈴木 啓司 on 2016/08/09.
//  Copyright © 2016年 suzuki_keishi. All rights reserved.
//

import Foundation
import UIKit

struct SKMesurement {
  static let isPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone
  static let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
  static var statusBarH: CGFloat {
    UIApplication.pbs_shared?.statusBarFrame.height ?? 0.0
  }

  static var screenHeight: CGFloat {
    UIApplication.pbs_shared?.preferredApplicationWindow?.bounds.height ?? UIScreen.main.bounds.height
  }

  static var screenWidth: CGFloat {
    UIApplication.pbs_shared?.preferredApplicationWindow?.bounds.width ?? UIScreen.main.bounds.width
  }

  static var screenScale: CGFloat {
    UIScreen.main.scale
  }

  static var screenRatio: CGFloat {
    screenWidth / screenHeight
  }

  static var isPhoneX: Bool {
    if isPhone && UIScreen.main.nativeBounds.height == 2436 {
      return true
    }
    return false
  }
}
