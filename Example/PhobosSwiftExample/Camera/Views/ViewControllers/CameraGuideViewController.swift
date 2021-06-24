//
//
//  CameraGuideViewController.swift
//  PhobosSwiftExample
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

import AVFoundation
import PhobosSwiftCore
import PhobosSwiftLog
import PhobosSwiftMedia
import RxCocoa
import RxSwift
import SnapKit
import UIKit

class CameraGuideViewController: UIViewController {
  let disposeBag = DisposeBag()

  var sessionMgr = PBSCameraSessionManager()

  lazy var captureButton: UIButton = {
    let button = UIButton(type: .system)
    view.addSubview(button)
    button.setImage(UIImage(named: "CapturePhoto"), for: .normal)
    return button
  }()

  lazy var flipCameraButton: UIButton = {
    let button = UIButton(type: .system)
    view.addSubview(button)
    button.setImage(UIImage(named: "FlipCamera"), for: .normal)
    return button
  }()

  lazy var cameraCropLayer: CALayer = {
    let _layer = CALayer()
    sessionMgr.cameraPreviewView.layer.addSublayer(_layer)
    _layer.borderColor = UIColor.red.cgColor
    _layer.borderWidth = 1.0
    _layer.backgroundColor = UIColor.clear.cgColor

    return _layer
  }()

  lazy var cameraView: PBSCameraPreviewView = {
    view.addSubview(sessionMgr.cameraPreviewView)
    return sessionMgr.cameraPreviewView
  }()

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    cameraCropLayer.frame = CGRect(x: 40, y: 80, width: cameraView.frame.size.width - 80, height: 256)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "获取框中的内容"
    view.backgroundColor = .pbs.systemBackground
    makeSubviews()

    if !PBSCameraSessionManager.isCameraAvailable {
      navigationItem.prompt = "摄像头不可用"
      return
    }

    sessionMgr.configure(captureOutputs: [.photoOutput], captureInputs: [.videoInput, .audioInput])

    makeControlEvent()
  }

  func makeSubviews() {
    cameraView.snp.makeConstraints {
      $0.left.right.bottom.equalTo(0)
      $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
      // $0.top.equalTo(self.topLayoutGuide.snp.bottom)
    }

    captureButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(cameraView.snp.bottom).offset(-66)
      $0.height.width.equalTo(60)
    }

    flipCameraButton.snp.makeConstraints {
      $0.centerX.equalToSuperview().multipliedBy(1.5)
      $0.bottom.equalTo(cameraView.snp.bottom).offset(-66)
      $0.height.width.equalTo(60)
    }
  }

  func makeControlEvent() {
    captureButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
      guard let self = self else { return }
      self.sessionMgr.capturePhoto()
    }).disposed(by: disposeBag)

    flipCameraButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
      guard let self = self else { return }
      self.sessionMgr.changeCamera()
    }).disposed(by: disposeBag)

    if #available(iOS 11.0, *) {
      self.sessionMgr.rx.didFinishProcessingPhoto.subscribe(onNext: { param in
        guard let photo = param.photo else { return }

        if let imageData = photo.fileDataRepresentation() {
          self.showResult(imageData: imageData)
        }

      }).disposed(by: disposeBag)
    } else {
      sessionMgr.rx.didFinishProcessingPhotoBuffer.subscribe(onNext: { param in
        guard let photoSampleBuffer = param.photoSampleBuffer else { return }

        if let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: param.previewPhotoSampleBuffer) {
          self.showResult(imageData: imageData)
        }
      }).disposed(by: disposeBag)
    }
  }

  private func showResult(imageData: Data) {
    if let image = UIImage(data: imageData) {
      let cropImage = sessionMgr.cropToPreviewLayer(originalImage: image, cropFrame: cameraCropLayer.frame)

      let imageViewCtrl = CameraGuidePreviewImageViewController()
      imageViewCtrl.imageView.image = cropImage

      present(imageViewCtrl, animated: true, completion: nil)
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    sessionMgr.startRunning(notAuthorized: {
      self.navigationItem.prompt = "doesn't have permission"
    }, configurationFailed: {
      self.navigationItem.prompt = "Unable to capture media"
    }, isAsync: true)
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    sessionMgr.stopRunning(isAsync: true)
  }
}

// extension CameraGuideViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//
//        print(imageBuffer)
//    }
// }
