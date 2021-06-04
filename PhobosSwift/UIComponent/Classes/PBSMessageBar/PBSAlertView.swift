//
//
//  PBSAlertView.swift
//  PhobosSwiftUIComponent
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
import PhobosSwiftCore
import RxCocoa
import RxSwift

public class PBSAlertViewWindow: UIWindow {
  public static var shared: PBSAlertViewWindow = {
    var window = PBSAlertViewWindow(frame: UIApplication.pbs_shared?.pbs_keyWindow?.frame ?? .zero)

    if #available(iOS 13.0, *) {
      if let windowScene = UIApplication.pbs_shared?.pbs_keyWindow?.windowScene {
        window = PBSAlertViewWindow(windowScene: windowScene)
      }
    }

    window.backgroundColor = .clear
    window.windowLevel = .alert

    window.rootViewController = PBSAlertController()

    return window
  }()

  public func showAlert(show: Bool) {
    Self.shared.isHidden = !show
    
  }

  override private init(frame: CGRect) {
    super.init(frame: frame)
  }

  @available(iOS 13.0, *)
  @available(iOSApplicationExtension 13.0, *)
  override private init(windowScene: UIWindowScene) {
    super.init(windowScene: windowScene)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

///
public struct PBSAlertViewModel {
  let disposeBag = DisposeBag()

  var uuid = UUID()
  ///
  public var message: String
  ///
  public var type: PBSAlertType
  ///
  public var dismissAfterSeconds: TimeInterval = .infinity
  ///
  public init(message: String, type: PBSAlertType, dismissAfterSeconds: TimeInterval = .infinity) {
    self.message = message
    self.type = type
    self.dismissAfterSeconds = dismissAfterSeconds
  }

  func countDown(_ completion: @escaping (UUID) -> Void) {
    guard dismissAfterSeconds != .infinity else {
      return
    }

    Observable<UUID>.just(uuid)
      .delay(RxTimeInterval.seconds(Int(dismissAfterSeconds)), scheduler: MainScheduler.instance)
      .subscribe(on: MainScheduler.instance).subscribe(onNext: { uuid in
        completion(uuid)

      }, onError: { error in
        print(error)
      }, onCompleted: {}, onDisposed: {}).disposed(by: disposeBag)
  }
}

class PBSAlertView: UIView {
  private lazy var statusIndicatorLayer: CALayer = {
    let layer = CALayer()

    return layer
  }()

  private lazy var contentLayer: CALayer = {
    let layer = CALayer()

    return layer
  }()

  private lazy var statusIconView: UIImageView = {
    let view = UIImageView(frame: .zero)
    self.addSubview(view)

    return view
  }()

  private lazy var messageLabel: UILabel = {
    let label = UILabel(frame: .zero)
    self.addSubview(label)
    label.lineBreakMode = .byWordWrapping
    label.numberOfLines = 0

    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    makeSubviews()
    makeStyles()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    let width: CGFloat = 12
    statusIndicatorLayer.frame = CGRect(x: 0, y: 0, width: width, height: bounds.height)
    contentLayer.frame = CGRect(x: width, y: 0, width: bounds.width - width, height: bounds.height)
  }

  private func makeSubviews() {
    layer.addSublayer(statusIndicatorLayer)
    layer.addSublayer(contentLayer)

    statusIconView.snp.makeConstraints {
      $0.left.equalTo(23)
      $0.top.equalTo(19)
      $0.width.height.equalTo(18.0)
    }

    messageLabel.snp.makeConstraints {
      $0.left.equalTo(statusIconView.snp.right).offset(14)
      $0.top.equalTo(13)
      $0.bottom.equalTo(-13)
      $0.right.equalTo(-20)
    }
  }

  private func makeStyles() {
    messageLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    statusIndicatorLayer.cornerRadius = 8.0
    if #available(iOS 11.0, *) {
      statusIndicatorLayer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    } else {}
    contentLayer.cornerRadius = 8.0
    if #available(iOS 11.0, *) {
      contentLayer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    } else {}
    contentLayer.backgroundColor = UIColor.pbs.tertiarySystemBackground.cgColor
  }

  func render(viewModel: PBSAlertViewModel) {
    messageLabel.text = viewModel.message
    statusIconView.tintColor = viewModel.type.color
    statusIconView.image = viewModel.type.image
    statusIndicatorLayer.backgroundColor = viewModel.type.color.cgColor
  }

  func renderCollapsed(viewModel: PBSAlertViewModel) {
    messageLabel.text = ""
    statusIconView.tintColor = viewModel.type.color
    statusIconView.image = viewModel.type.image
    statusIndicatorLayer.backgroundColor = viewModel.type.color.cgColor
  }
}

public enum PBSAlertType: String, Codable {
  case success
  case warning
  case info
  case error

  var color: UIColor {
    switch self {
    case .success:
      return UIColor.pbs.color(hex: 0x5CC08C)
    case .warning:
      return UIColor.pbs.color(hex: 0xE2B236)
    case .info:
      return UIColor.pbs.color(hex: 0x007AD2)
    case .error:
      return UIColor.pbs.color(hex: 0xE9382C)
    }
  }

  var image: UIImage {
    switch self {
    case .success:
      return UIImage.image(named: "message_bar_success").withRenderingMode(.alwaysTemplate)
    case .warning:
      return UIImage.image(named: "message_bar_warning").withRenderingMode(.alwaysTemplate)
    case .info:
      return UIImage.image(named: "message_bar_info").withRenderingMode(.alwaysTemplate)
    case .error:
      return UIImage.image(named: "message_bar_error").withRenderingMode(.alwaysTemplate)
    }
  }
}

///
public struct PBSAlertManager {
  ///
  public static let shared = PBSAlertManager()
}

