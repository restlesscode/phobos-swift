//
//
//  PBSMedia.swift
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

import AVFoundation
import Foundation
import PhobosSwiftCore
import PhobosSwiftLog
import Photos

/// PBSMedia 将AVFoundation常用的方法做了封装，让调用更简单
///
/// 整个App生命周期，确保保只需要一个PBSMedia即可
public class PBSMedia: NSObject {
  override private init() {
    super.init()
  }

  /// 如果用户没有授权，是否弹出默认的Alert提示
  public static var enableUnauthorizationAlert = true

  /// cameraAuthorizationAlertCtrl
  public static var cameraAuthorizationAlertCtrl: UIAlertController = {
    makeAlertCtrl(title: BUString.kAllowCameraAccess, message: BUString.kAllowCameraAccessMessage)

  }()

  public static var defaultCaptureDevice: AVCaptureDevice? {
    AVCaptureDevice.default(for: AVMediaType.video)
  }

  /// photoAuthorizationAlertCtrl
  static var photoAuthorizationAlertCtrl: UIAlertController = {
    makeAlertCtrl(title: BUString.kAllowPhotoAccess, message: BUString.kAllowPhotoAccessMessage)

  }()

  private static func makeAlertCtrl(title: String, message: String) -> UIAlertController {
    let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: .alert)

    alertCtrl.addAction(UIAlertAction(title: BUString.kSettings, style: .default) { _ in
      alertCtrl.dismiss(animated: true, completion: nil)

      if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
        if UIApplication.pbs_shared?.canOpenURL(settingsURL) ?? false {
          UIApplication.pbs_shared?.pbs_open(settingsURL, options: [:], completionHandler: nil)
        }
      }
    })

    alertCtrl.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
      alertCtrl.dismiss(animated: true, completion: nil)
    })

    return alertCtrl
  }

  /// Camera授权状态
  public static var cameraAuthorizationStatus: AVAuthorizationStatus {
    AVCaptureDevice.authorizationStatus(for: .video)
  }

  /// Photo授权状态
  public static var photoAuthorizationStatus: PHAuthorizationStatus {
    PHPhotoLibrary.authorizationStatus()
  }

  /// Check Camera是否被授权
  public static func checkCameraAuthorizationStatus(handler: ((AVAuthorizationStatus) -> Void)? = nil) {
    let _cameraAuthorizationStatus = cameraAuthorizationStatus
    switch _cameraAuthorizationStatus {
    // The user has previously granted access to the camera.
    case .authorized:
      handler?(_cameraAuthorizationStatus)

    // The user has not yet been asked for camera access.
    case .notDetermined:
      PBSMedia.requestVideoAccess(completionHandler: { _ in
        handler?(cameraAuthorizationStatus)
      })

    // The user has previously denied access.
    case .denied,
         // The user can't grant access due to restrictions.
         .restricted:
      handler?(_cameraAuthorizationStatus)

      DispatchQueue.pbs_once {
        if PBSMedia.enableUnauthorizationAlert {
          if cameraAuthorizationAlertCtrl.presentingViewController == nil && !cameraAuthorizationAlertCtrl.isBeingPresented {
            DispatchQueue.main.async {
              UIApplication.pbs_shared?.keyWindow?.rootViewController?.present(cameraAuthorizationAlertCtrl, animated: true, completion: nil)
            }
          }
        }
      }
    @unknown default:
      fatalError("Not support yet")
    }
  }

  /// Check Photo是否被授权
  public static func checkPhotoAuthorizationStatus(handler: ((PHAuthorizationStatus) -> Void)? = nil) {
    let _photoAuthorizationStatus = photoAuthorizationStatus
    switch photoAuthorizationStatus {
    // The user has previously granted access to the photo.
    case .authorized:
      handler?(_photoAuthorizationStatus)

    // The user has not yet been asked for photo access.
    case .notDetermined:
      PBSMedia.requestPhotoAccess { status in
        handler?(status)
      }

    // The user has previously denied access.
    case .denied,
         // The user can't grant access due to restrictions.
         .restricted:
      handler?(_photoAuthorizationStatus)

      DispatchQueue.pbs_once {
        if PBSMedia.enableUnauthorizationAlert {
          if photoAuthorizationAlertCtrl.presentingViewController == nil && !photoAuthorizationAlertCtrl.isBeingPresented {
            DispatchQueue.main.async {
              UIApplication.pbs_shared?.keyWindow?.rootViewController?.present(photoAuthorizationAlertCtrl, animated: true, completion: nil)
            }
          }
        }
      }
    case .limited:
      fatalError("Not support yet")
    @unknown default:
      fatalError("Not support yet")
    }
  }

  public static func requestVideoAccess(completionHandler handler: @escaping (Bool) -> Void) {
    AVCaptureDevice.requestAccess(for: .video, completionHandler: handler)
  }

  public static func requestPhotoAccess(_ handler: @escaping (PHAuthorizationStatus) -> Void) {
    PHPhotoLibrary.requestAuthorization(handler)
  }
}
