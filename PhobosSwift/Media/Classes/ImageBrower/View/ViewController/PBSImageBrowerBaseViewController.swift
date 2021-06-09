//
//
//  PBSImageBrowerBaseViewController.swift
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

import UIKit

public protocol PBSMPViewControllerProtocol: UIViewController {
  func updateData()
  func showMessage(_ message: String)
  func showLoading()
  func hiddenLoading()
  func requestOver(errorMessage: String?)
}

open class PBSMPVMBase: NSObject {
  public weak var delegate: PBSMPViewControllerProtocol?
}

private let GIO_PAGE_NAME_KEY = "ios_page_name"

extension PBSImageBrower {
  open class BaseViewController: UIViewController {
    /// 来源方式 push present
    public var isPush = true

    public lazy var tableView: UITableView = getSimpleTableView()

    /// StatusBarStyle
    override open var preferredStatusBarStyle: UIStatusBarStyle {
      .default
    }

    private lazy var defaultLabel: UILabel = {
      let label = UILabel()
      label.font = UIFont.systemFont(ofSize: 14)
      label.textColor = PBSImageBrower.Color.blackWhite
      label.textAlignment = .center
      return label
    }()

    override open func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
      baseInit()

      //        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override open func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      // 管理导航栏显示隐藏策略
      if navigationItem.title == nil || navigationItem.title == "" {
        hiddenNavigationBar(true)
      } else {
        hiddenNavigationBar(false)
      }
    }

    /// 隐藏显示导航条
    ///
    /// - Parameter isHidden: 是否隐藏
    func hiddenNavigationBar(_ isHidden: Bool) {
      if navigationController?.isNavigationBarHidden != isHidden {
        navigationController?.setNavigationBarHidden(isHidden, animated: true)
      }
    }

    /// 导航栏初始化
    @objc open func baseInit() {
      // 设置默认背景色
      view.backgroundColor = PBSImageBrower.Color.whiteGrey8
      // 添加返回按钮
      addBackButton()

      navigationController?.navigationBar.barTintColor = PBSImageBrower.Color.whiteGrey8
      // 去除分割线
      navigationController?.navigationBar.shadowImage = UIImage()
      navigationController?.navigationBar.backgroundColor = PBSImageBrower.Color.whiteGrey8
      navigationController?.navigationBar.isTranslucent = false

      // 标题颜色
      navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: PBSImageBrower.Color.blackWhite, .font: UIFont.boldSystemFont(ofSize: 17)]
      /// 导航栏偏移解决
      if #available(iOS 11.0, *) {
      } else {
        automaticallyAdjustsScrollViewInsets = false
      }
    }

    func addBackButton() {
      let bundleImageResource = isPush == true ? baseBundle.image(withName: "back") : baseBundle.image(withName: "icon_close")
      let barButtonItem = UIBarButtonItem(image: bundleImageResource, style: .plain, target: self, action: #selector(back))
      barButtonItem.tintColor = PBSImageBrower.Color.blackWhite
      navigationItem.leftBarButtonItem = barButtonItem
    }

    @objc open func back() {
      if isPush {
        navigationController?.popViewController(animated: true)
      } else {
        dismiss(animated: true, completion: nil)
      }
    }

    public func addCloseButton() {
      navigationItem.leftBarButtonItem = nil
      let bundleImageResource = baseBundle.image(withName: "icon_close")
      let barButtonItem = UIBarButtonItem(image: bundleImageResource, style: .plain, target: self, action: #selector(back))
      barButtonItem.tintColor = PBSImageBrower.Color.blackWhite
      navigationItem.rightBarButtonItem = barButtonItem
    }

    /// 设置TableView ContentInsetAdjustmentBehavior 为 .nerver
    public func setContentInsetAdjustmentBehavior() {
      // 防止状态栏留白
      if #available(iOS 11.0, *) {
        tableView.contentInsetAdjustmentBehavior = .never
      }
    }

    public func showNavigatorLine() {
      let line = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 0.5))
      line.backgroundColor = PBSImageBrower.Color.grey1Black
      view.addSubview(line)
    }

    public func getSimpleTableView() -> UITableView {
      let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.pbs.width, height: ScreenHeight - NavigationBarHeight))
      tableView.separatorStyle = .none
      tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: bottomSpace, right: 0)
      tableView.backgroundColor = PBSImageBrower.Color.whiteGrey8
      tableView.delegate = self
      tableView.dataSource = self
      tableView.showsVerticalScrollIndicator = false
      return tableView
    }
  }
}

extension PBSImageBrower.BaseViewController: UITableViewDelegate, UITableViewDataSource {
  open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    0
  }

  open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    UITableViewCell()
  }
}

extension PBSImageBrower.BaseViewController: PBSMPViewControllerProtocol {
  @objc open func requestOver(errorMessage: String?) {
    hiddenLoading()
  }

  @objc open func updateData() {}

  public func showMessage(_ message: String) {
    DispatchQueue.main.async {
      self.hiddenLoading()
    }
  }

  public func showLoading() {}

  public func hiddenLoading() {}
}

extension PBSImageBrower.BaseViewController {
  /// :nodoc:
  public func showNoDataLabel(message: String, top: CGFloat = 120) {
    if defaultLabel.superview == nil {
      view.addSubview(defaultLabel)
    }

    defaultLabel.text = message
    defaultLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(top + NavigationBarHeight)
    }
  }

  /// :nodoc:
  public func hiddenNoDataLabel() {
    defaultLabel.removeFromSuperview()
  }
}
