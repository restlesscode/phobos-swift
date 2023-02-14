//
//
//  PBSGrowthFeedbackViewController.swift
//  PhobosSwiftGrowth
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

import PhobosSwiftCore
import PhobosSwiftMedia
import RxCocoa
import RxSwift
import SnapKit
import UIKit

class PBSGrowthFeedbackViewController: UIViewController {
  var model: PBSGrowthHomeItemModel?

  let viewModel = PBSGrowthFeedbackViewModel()

  let cancelButton = UIButton()
  let titleLabel = UILabel()
  let bottomLine = UIView()
  let scrollView = UIScrollView()
  let commitButton = UIButton()
  let headerView = PBSGrowthFeedbackHeaderView()
  let textView = PBSGrowthFeedbackTextView()
  let mediaView = PBSGrowthFeedbackMediaView()
  private let disposeBag = DisposeBag()
  convenience init(model: PBSGrowthHomeItemModel) {
    self.init(nibName: nil, bundle: nil)
    self.model = model
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
    makeConstraints()
    setData()
  }

  func setUI() {
    view.backgroundColor = .pbs.color(R: 28, G: 28, B: 30)
    cancelButton.setTitle("Cancel", for: .normal)
    cancelButton.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside)
    cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    cancelButton.setTitleColor(.pbs.color(R: 0, G: 122, B: 255), for: .normal)
    view.addSubview(cancelButton)
    titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    titleLabel.textAlignment = .center
    titleLabel.text = "Give us your feedback"
    titleLabel.textColor = .white
    titleLabel.adjustsFontSizeToFitWidth = true
    view.addSubview(titleLabel)
    bottomLine.backgroundColor = .pbs.color(R: 255, G: 255, B: 255, alpha: 0.15)
    view.addSubview(bottomLine)
    if #available(iOS 11.0, *) {
      scrollView.contentInsetAdjustmentBehavior = .never
    }
    view.addSubview(scrollView)
    scrollView.addSubview(headerView)
    scrollView.addSubview(textView)
    scrollView.addSubview(mediaView)

    commitButton.setTitle("Submit", for: .normal)
    commitButton.setTitleColor(.pbs.color(R: 252, G: 252, B: 252), for: .normal)
    commitButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
    commitButton.layer.cornerRadius = 8
    commitButton.backgroundColor = .pbs.color(R: 44, G: 44, B: 46)
    commitButton.isHidden = true

    view.addSubview(commitButton)
  }

  func makeConstraints() {
    cancelButton.snp.makeConstraints { make in
      make.top.left.equalToSuperview()
      make.bottom.equalTo(bottomLine.snp.top)
      make.width.equalTo(85)
    }
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.left.equalTo(cancelButton.snp.right)
      make.right.equalToSuperview().offset(-85)
      make.bottom.equalTo(bottomLine.snp.top)
    }
    bottomLine.snp.makeConstraints { make in
      make.right.left.equalToSuperview()
      make.height.equalTo(1 / UIScreen.main.scale)
      make.top.equalToSuperview().offset(58)
    }
    scrollView.snp.makeConstraints { make in
      make.right.left.bottom.equalToSuperview()
      make.top.equalTo(bottomLine.snp.bottom)
    }
    headerView.snp.makeConstraints { make in
      make.top.left.equalToSuperview()
      make.width.equalTo(view.snp.width)
    }
    textView.snp.makeConstraints { make in
      make.top.equalTo(headerView.snp.bottom)
      make.left.equalToSuperview()
      make.width.equalTo(view.snp.width)
      make.height.equalTo(205)
    }
    mediaView.snp.makeConstraints { make in
      make.top.equalTo(textView.snp.bottom)
      make.left.equalToSuperview()
      make.width.equalTo(view.snp.width)
      make.height.equalTo(200)
      make.bottom.equalToSuperview().offset(-100)
    }
    commitButton.snp.makeConstraints { make in
      make.height.equalTo(48)
      make.left.equalToSuperview().offset(20)
      make.right.equalToSuperview().offset(-20)
      make.bottom.equalToSuperview().offset(-50)
    }

    _ = mediaView.addedClick.asObservable().subscribe { [weak self] _ in
      guard let self = self else { return }
      self.addMedia()
    }.disposed(by: disposeBag)

    _ = mediaView.removeClick.asObservable().subscribe { [weak self] event in
      guard let self = self else { return }
      if case let .next(value) = event {
        self.removeMedia(at: value)
      }
    }.disposed(by: disposeBag)

    _ = textView.textView.rx.text.orEmpty.asObservable().subscribe(onNext: { [weak self] text in
      guard let self = self else { return }
      self.viewModel.textPublishSubject.onNext(text)
      self.viewModel.updateData.onNext(self.viewModel.hasData)
    }).disposed(by: disposeBag)

    _ = viewModel.updateData.asObservable().subscribe(onNext: { [weak self] hasData in
      guard let self = self else { return }
      self.mediaView.collectionView.reloadData()
      self.commitButton.isHidden = (self.textView.textView.text.count <= 0) || !hasData
      self.mediaView.countLabel.text = String(self.viewModel.dataCount)
    }).disposed(by: disposeBag)

    mediaView.viewModel = viewModel
  }

  func setData() {
    headerView.titleLabel.text = model?.title
    headerView.subTitleLabel.text = model?.subTitle
  }

  func addMedia() {
    let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    actionSheetController.addAction(UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
      guard let self = self else { return }
      self.openCamera()
    })
    actionSheetController.addAction(UIAlertAction(title: "Photo", style: .default) { [weak self] _ in
      guard let self = self else { return }
      self.openPhotoLibrary()
    })
    actionSheetController.addAction(UIAlertAction(title: "cancel", style: .cancel))
    if UI_USER_INTERFACE_IDIOM() == .phone {
      present(actionSheetController, animated: true, completion: nil)
    } else {
      actionSheetController.modalPresentationStyle = .popover
      present(actionSheetController, animated: true, completion: { () in
      })
    }
  }

  func removeMedia(at index: Int) {
    let actionSheetController = UIAlertController(title: "Delete Image?", message: nil, preferredStyle: .alert)
    actionSheetController.addAction(UIAlertAction(title: "Sure", style: .default) { [weak self] _ in
      guard let self = self else { return }
      self.viewModel.removeMedia.onNext(index)
    })
    actionSheetController.addAction(UIAlertAction(title: "cancel", style: .cancel))
    present(actionSheetController, animated: true, completion: nil)
  }

  func openCamera() {
    if !PBSCameraSessionManager.isCameraAvailable {
      print("Camera not available")
      return
    }
    let controller = UIImagePickerController()
    controller.sourceType = .camera
    controller.delegate = self
    controller.cameraDevice = .rear
    controller.modalPresentationStyle = .fullScreen
    present(controller, animated: true, completion: nil)
  }

  func openPhotoLibrary() {
    let selectViewController = PBSImageBrower.SelectViewController()
    selectViewController.selectBlock = { [weak self] images in
      guard let self = self else { return }
      images.forEach { image in
        guard let imageData = image.pngData() else { return }
        self.viewModel.addMedia.onNext(PBSGrowthFeedbackViewModel.MediaImageModel(image: image, imageData: imageData))
      }
    }
    let vc = UINavigationController(rootViewController: selectViewController)
    selectViewController.maxSelectCount = 2
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: true, completion: nil)
  }

  @objc func cancelButtonClick() {
    dismiss(animated: true, completion: nil)
  }
}

extension PBSGrowthFeedbackViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    guard let image = info[.originalImage] as? UIImage, let imageData = image.pngData() else { return }
    viewModel.addMedia.onNext(PBSGrowthFeedbackViewModel.MediaImageModel(image: image, imageData: imageData))
    picker.dismiss(animated: true, completion: nil)
  }
}
