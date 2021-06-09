//
//
//  PBSColor.swift
//  PhobosSwiftMedia
//
//  Copyright (c) 2021 Restless Codes Team (https://github.com/restlesscode/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

public class PBSImageBrowerColor: NSObject {
  public static var share = PBSImageBrowerColor()

  public let vehicleSizeProportion: CGFloat = 0.5625

  override private init() {
    super.init()
  }

  public func getRedLabel(size: CGSize) -> UILabel {
    let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: size))
    label.textColor = PBSImageBrowerColor.white
    label.font = UIFont.boldSystemFont(ofSize: 12)
    label.textAlignment = .center
    label.backgroundColor = PBSImageBrowerColor.porscheRed

    return label
  }
}

extension PBSImageBrowerColor {
  static let blue = UIColor.blue

  /// shadow color
  public static let shadow: UIColor = {
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "shadow", in: baseBundle, compatibleWith: nil) {
        return color
      }
    }
    return UIColor.pbs.color(R: 189, G: 199, B: 207)
  }()

  /// white always
  public static let white: UIColor = {
    UIColor.white
  }()

  /// black always
  public static let black: UIColor = {
    UIColor.black
  }()

  /// day = black, dark = white
  public static let blackWhite: UIColor = {
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "black_white", in: baseBundle, compatibleWith: nil) {
        return color
      }
    }
    return UIColor.black
  }()

  /// line color
  public static let line: UIColor = {
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "line", in: baseBundle, compatibleWith: nil) {
        return color
      }
    }
    return UIColor.pbs.color(R: 242, G: 242, B: 242)
  }()

  /// divider color
  public static let divider: UIColor = {
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "divider", in: baseBundle, compatibleWith: nil) {
        return color
      }
    }
    return UIColor.pbs.color(R: 242, G: 244, B: 246)
  }()

  /// day = grey216, dark = grey6
  public static let grey216Grey6: UIColor = {
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "grey216_grey6", in: baseBundle, compatibleWith: nil) {
        return color
      }
    }
    return UIColor.pbs.color(R: 216, G: 216, B: 216)
  }()

  /// grey216 always
  public static let grey216: UIColor = {
    UIColor.pbs.color(R: 216, G: 216, B: 216)
  }()

  /// replace color
  public static let porscheRed: UIColor = {
    let defaultColor = UIColor.pbs.color(hexString: "#d5001c")
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "porsche_red", in: baseBundle, compatibleWith: nil) {
        return color
      } else {
        return defaultColor
      }
    }
    return defaultColor
  }()

  /// error red
  public static let errorRed: UIColor = {
    let defaultColor = UIColor.pbs.color(hexString: "#E00000")
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "error_red", in: baseBundle, compatibleWith: nil) {
        return color
      } else {
        return defaultColor
      }
    }
    return defaultColor
  }()

  /// day = grey1, dark = grey7
  public static let grey1Grey7: UIColor = {
    let defaultColor = UIColor.pbs.color(hexString: "#EFF0F1")
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "grey1_grey7", in: baseBundle, compatibleWith: nil) {
        return color
      } else {
        return defaultColor
      }
    }
    return defaultColor
  }()

  /// :nodoc:
  public static let grey1Black: UIColor = {
    let defaultColor = UIColor.pbs.color(hexString: "#EFF0F1")
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "grey1_black", in: baseBundle, compatibleWith: nil) {
        return color
      } else {
        return defaultColor
      }
    }
    return defaultColor
  }()

  /// :nodoc:
  public static let grey242Black: UIColor = {
    let defaultColor = UIColor.pbs.color(hexString: "#F2F2F7")
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "grey242_black", in: baseBundle, compatibleWith: nil) {
        return color
      } else {
        return defaultColor
      }
    }
    return defaultColor
  }()

  /// day = grey1, dark = grey6
  public static let grey1Grey6: UIColor = {
    let defaultColor = UIColor.pbs.color(hexString: "#EFF0F1")
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "grey1_grey6", in: baseBundle, compatibleWith: nil) {
        return color
      } else {
        return defaultColor
      }
    }
    return defaultColor
  }()

  /// day = grey2, dark = grey6
  public static let grey2Grey6: UIColor = {
    let defaultColor = UIColor.pbs.color(hexString: "#C9CACB")
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "grey2_grey6", in: baseBundle, compatibleWith: nil) {
        return color
      } else {
        return defaultColor
      }
    }
    return defaultColor
  }()

  /// grey2 always
  public static let grey2: UIColor = {
    UIColor.pbs.color(hexString: "#C9CACB")
  }()

  /// grey4 always
  public static let grey4: UIColor = {
    let defaultColor = UIColor.pbs.color(hexString: "#7C7F81")
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "grey4", in: baseBundle, compatibleWith: nil) {
        return color
      } else {
        return defaultColor
      }
    }
    return defaultColor
  }()

  /// day = grey5, dark = grey3
  public static let grey5Grey3: UIColor = {
    let defaultColor = UIColor.pbs.color(hexString: "#626669")
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "grey5_grey3", in: baseBundle, compatibleWith: nil) {
        return color
      } else {
        return defaultColor
      }
    }
    return defaultColor
  }()

  /// day = #626669, dark = #B0B1B2
  public static let grey5GreyB0: UIColor = {
    let defaultColor = UIColor.pbs.color(hexString: "#626669")
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "grey5_b0", in: baseBundle, compatibleWith: nil) {
        return color
      } else {
        return defaultColor
      }
    }
    return defaultColor
  }()

  /// premium gold
  public static let premiumGold: UIColor = {
    let defaultColor = UIColor.pbs.color(hexString: "#E7C684")
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "premium_gold", in: baseBundle, compatibleWith: nil) {
        return color
      } else {
        return defaultColor
      }
    }
    return defaultColor
  }()

  /// soulful blue
  public static let soulfulBlue: UIColor = {
    let defaultColor = UIColor.pbs.color(hexString: "#00B0F4")
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "soulful_blue", in: baseBundle, compatibleWith: nil) {
        return color
      } else {
        return defaultColor
      }
    }
    return defaultColor
  }()

  /// success green
  public static let successGreen: UIColor = {
    let defaultColor = UIColor.pbs.color(hexString: "#13D246")
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "success_green", in: baseBundle, compatibleWith: nil) {
        return color
      } else {
        return defaultColor
      }
    }
    return defaultColor
  }()

  /// warning yellow
  public static let warningYellow: UIColor = {
    let defaultColor = UIColor.pbs.color(hexString: "#E2B236")
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "warning_yellow", in: baseBundle, compatibleWith: nil) {
        return color
      } else {
        return defaultColor
      }
    }
    return defaultColor
  }()

  /// default day = white, dark = grey8
  public static let whiteGrey8: UIColor = {
    let defaultColor = UIColor.pbs.color(hexString: "#FFFFFF")
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "white_grey8", in: baseBundle, compatibleWith: nil) {
        return color
      } else {
        return defaultColor
      }
    }
    return defaultColor
  }()

  /// special day = white, dark = grey7
  public static let whiteGrey7: UIColor = {
    let defaultColor = UIColor.pbs.color(hexString: "#FFFFFF")
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "white_grey7", in: baseBundle, compatibleWith: nil) {
        return color
      } else {
        return defaultColor
      }
    }
    return defaultColor
  }()

  ///
  public static let vehicleTint: UIColor = {
    let defaultColor = UIColor.pbs.color(hexString: "#333639")
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "vehicle_tint", in: baseBundle, compatibleWith: nil) {
        return color
      } else {
        return defaultColor
      }
    }
    return defaultColor
  }()

  ///
  public static let liveChatMessageBgColor: UIColor = {
    let defaultColor = UIColor.pbs.color(hexString: "#323639")
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "livechat_mes_bg", in: baseBundle, compatibleWith: nil) {
        return color
      } else {
        return defaultColor
      }
    }
    return defaultColor
  }()

  public static let colorDivider: UIColor = {
    let defaultColor = UIColor.pbs.color(hexString: "#E7E7E7")
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "color_divider", in: baseBundle, compatibleWith: nil) {
        return color
      } else {
        return defaultColor
      }
    }
    return defaultColor
  }()

  public static let colorSearchBg: UIColor = {
    let defaultColor = UIColor.pbs.color(hexString: "#F2F2F2")
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "color_search_bg", in: baseBundle, compatibleWith: nil) {
        return color
      } else {
        return defaultColor
      }
    }
    return defaultColor
  }()

  public static let grey9Grey10: UIColor = {
    let defaultColor = UIColor.pbs.color(hexString: "#4A4E51")
    if #available(iOS 11.0, *) {
      if let color = UIColor(named: "grey9_grey10", in: baseBundle, compatibleWith: nil) {
        return color
      } else {
        return defaultColor
      }
    }
    return defaultColor
  }()
}
