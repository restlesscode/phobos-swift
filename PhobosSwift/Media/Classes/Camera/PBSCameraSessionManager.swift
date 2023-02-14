//
//
//  PBSCameraSessionManager.swift
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
import PhobosSwiftCore
import PhobosSwiftLog
import UIKit

private let kLog = PBSLogger.shared
private let kCameraQueue = "cameraQueue"

///
public enum PBSCameraSessionSetupResult {
  ///
  case success
  ///
  case notAuthorized
  ///
  case configurationFailed
}

///
public enum SwitchMode {
  ///
  case on
  ///
  case off
}

///
public struct PBSCameraSessionInputs: OptionSet {
  public let rawValue: Int

  public static let videoInput = PBSCameraSessionInputs(rawValue: 1)
  public static let audioInput = PBSCameraSessionInputs(rawValue: 2)

  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
}

///
public struct PBSCameraSessionOutputs: OptionSet {
  public let rawValue: Int

  public static let photoOutput = PBSCameraSessionOutputs(rawValue: 1)
  public static let videoOutput = PBSCameraSessionOutputs(rawValue: 2)
  public static let mediaOutput = PBSCameraSessionOutputs(rawValue: 4)

  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
}

/// Manager of Camera Session
public class PBSCameraSessionManager: NSObject {
  public weak var delegate: PBSCameraSessionManagerDelegate?

  var windowOrientation: UIInterfaceOrientation {
    if #available(iOS 13.0, *) {
      return UIWindow.pbs.keyWindowTopMostController?.view.window?.windowScene?.interfaceOrientation ?? .unknown
    } else {
      return .unknown
    }
  }

  ///
  public let photoOutput = AVCapturePhotoOutput()
  /// Recording Movies Output
  var movieFileOutput: AVCaptureMovieFileOutput?
  ///
  public var mediaOutputRectOfInterest: CGRect = .zero
  ///
  public let videoOutput = AVCaptureVideoDataOutput()
  ///
  public let mediaOutput = AVCaptureMetadataOutput()
  ///
  public let captureSession = AVCaptureSession()
  ///
  public var isSessionRunning: Bool {
    captureSession.isRunning
  }

  ///
  public var setupResult: PBSCameraSessionSetupResult = .success
  ///
  public let sessionQueue = DispatchQueue(label: kCameraQueue, qos: .userInitiated)
  ///
  public dynamic var videoDeviceInput: AVCaptureDeviceInput?
  ///
  public let videoDeviceDiscoverySession: AVCaptureDevice.DiscoverySession!

  private var _livePhotoMode: SwitchMode = .off
  ///
  public var livePhotoMode: SwitchMode {
    get {
      if !photoOutput.isLivePhotoCaptureSupported {
        return .off
      }
      return _livePhotoMode
    }
    set {
      _livePhotoMode = newValue
    }
  }

  private var _depthDataDeliveryMode: SwitchMode = .off
  ///
  public var depthDataDeliveryMode: SwitchMode {
    get {
      if #available(iOS 11.0, *) {
        if !photoOutput.isDepthDataDeliverySupported {
          return .off
        }
      }
      return _depthDataDeliveryMode
    }
    set {
      _depthDataDeliveryMode = newValue
    }
  }

  ///
  public var metadataObjectTypes: [AVMetadataObject.ObjectType] = [AVMetadataObject.ObjectType.qr,
                                                                   AVMetadataObject.ObjectType.ean13,
                                                                   AVMetadataObject.ObjectType.code128]

  private var _portraitEffectsMatteDeliveryMode: SwitchMode = .off
  ///
  public var portraitEffectsMatteDeliveryMode: SwitchMode {
    get {
      if #available(iOS 12.0, *) {
        if !photoOutput.isPortraitEffectsMatteDeliverySupported {
          return .off
        }
      }
      return _portraitEffectsMatteDeliveryMode
    }
    set {
      _portraitEffectsMatteDeliveryMode = newValue
    }
  }

  /// # camera preview view
  public lazy var cameraPreviewView: PBSCameraPreviewView = {
    let _view = PBSCameraPreviewView()
    _view.session = self.captureSession
    _view.videoPreviewLayer.videoGravity = .resizeAspectFill

    return _view
  }()

  /// # camera avaliable
  public static var isCameraAvailable: Bool {
    let device = AVCaptureDevice.default(for: .video)
    return device != nil
  }

  ///
  override public init() {
    if #available(iOS 10.2, *) {
      self.defaultCameraType = .builtInDualCamera
    } else {
      defaultCameraType = .builtInWideAngleCamera
    }

    var deviceTypes: [AVCaptureDevice.DeviceType] = []
    if #available(iOS 11.1, *) {
      deviceTypes = [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera]
    } else if #available(iOS 10.2, *) {
      deviceTypes = [.builtInWideAngleCamera, .builtInDualCamera]
    } else {
      deviceTypes = [.builtInWideAngleCamera]
    }
    videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: deviceTypes,
                                                                   mediaType: .video,
                                                                   position: .unspecified)

    super.init()
    livePhotoMode = .off
    depthDataDeliveryMode = .off
  }

  func addVideoInput() -> Bool {
    // Add video input.
    do {
      var defaultVideoDevice: AVCaptureDevice?

      // Choose the back dual camera, if available, otherwise default to a wide angle camera.
      if let cameraDevice = AVCaptureDevice.default(defaultCameraType, for: .video, position: defaultCameraPostion) {
        defaultVideoDevice = cameraDevice
      } else if
        #available(iOS 10.2, *),
        let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
        defaultVideoDevice = dualCameraDevice
      } else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
        // If a rear dual camera is not available, default to the rear wide angle camera.
        defaultVideoDevice = backCameraDevice
      } else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
        // If the rear wide angle camera isn't available, default to the front wide angle camera.
        defaultVideoDevice = frontCameraDevice
      }

      guard let videoDevice = defaultVideoDevice else {
        kLog.info(message: "Default video device is unavailable.")
        setupResult = .configurationFailed
        return false
      }
      let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)

      if captureSession.canAddInput(videoDeviceInput) {
        captureSession.addInput(videoDeviceInput)
        self.videoDeviceInput = videoDeviceInput

        DispatchQueue.main.async {
          /*
           Dispatch video streaming to the main queue because AVCaptureVideoPreviewLayer is the backing layer for PreviewView.
           You can manipulate UIView only on the main thread.
           Note: As an exception to the above rule, it's not necessary to serialize video orientation changes
           on the AVCaptureVideoPreviewLayer’s connection with other session manipulation.

           Use the window scene's orientation as the initial video orientation. Subsequent orientation changes are
           handled by CameraViewController.viewWillTransition(to:with:).
           */
          var initialVideoOrientation: AVCaptureVideoOrientation = .portrait
          if self.windowOrientation != .unknown {
            if let videoOrientation = AVCaptureVideoOrientation(rawValue: self.windowOrientation.rawValue) {
              initialVideoOrientation = videoOrientation
            }
          }

          self.cameraPreviewView.videoPreviewLayer.connection?.videoOrientation = initialVideoOrientation
        }
      } else {
        kLog.info(message: "Couldn't add video device input to the session.")
        setupResult = .configurationFailed
        return false
      }
    } catch {
      kLog.info(message: "Couldn't create video device input: \(error)")
      setupResult = .configurationFailed
      return false
    }

    return true
  }

  func addAudioInput() -> Bool {
    // Add an audio input device.
    guard let audioDevice = AVCaptureDevice.default(for: .audio) else {
      kLog.info(message: "Could not create audio device")
      setupResult = .configurationFailed
      return false
    }
    do {
      let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice)

      if captureSession.canAddInput(audioDeviceInput) {
        captureSession.addInput(audioDeviceInput)
      } else {
        kLog.info(message: "Could not add audio device input to the session")
        return false
      }
    } catch {
      kLog.info(message: "Could not create audio device input: \(error)")
      return false
    }
    return true
  }

  func addPhotoOutput() -> Bool {
    // Add the photo output.
    if captureSession.canAddOutput(photoOutput) {
      captureSession.addOutput(photoOutput)

      photoOutput.isHighResolutionCaptureEnabled = true
      photoOutput.isLivePhotoCaptureEnabled = photoOutput.isLivePhotoCaptureSupported
      if #available(iOS 11.0, *) {
        photoOutput.isDepthDataDeliveryEnabled = photoOutput.isDepthDataDeliverySupported
      }
      if #available(iOS 12.0, *) {
        photoOutput.isPortraitEffectsMatteDeliveryEnabled = photoOutput.isPortraitEffectsMatteDeliverySupported
      }
      if #available(iOS 13.0, *) {
        photoOutput.enabledSemanticSegmentationMatteTypes = photoOutput.availableSemanticSegmentationMatteTypes
        photoOutput.maxPhotoQualityPrioritization = .quality
      }

    } else {
      kLog.info(message: "Could not add photo output to the session")
      setupResult = .configurationFailed
      return false
    }

    return true
  }

  func addMediaOutput() -> Bool {
    guard let videoDeviceInput = videoDeviceInput else { return false }

    if captureSession.canAddOutput(mediaOutput) {
      captureSession.addOutput(mediaOutput)
      mediaOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      mediaOutput.metadataObjectTypes = metadataObjectTypes
      if mediaOutputRectOfInterest != .zero {
        mediaOutput.rectOfInterest = mediaOutputRectOfInterest
      }

      if videoDeviceInput.device.isFocusPointOfInterestSupported && videoDeviceInput.device.isFocusModeSupported(
        AVCaptureDevice.FocusMode.continuousAutoFocus) {
        do {
          try videoDeviceInput.device.lockForConfiguration()
          videoDeviceInput.device.focusMode = AVCaptureDevice.FocusMode.continuousAutoFocus
          videoDeviceInput.device.unlockForConfiguration()
        } catch let error as NSError {
          kLog.info(message: "device.lockForConfiguration(): \(error)")
        }
      }

    } else {
      kLog.info(message: "Could not add photo output to the session")
      setupResult = .configurationFailed
      return false
    }
    return true
  }

  ///
  public func checkAuthorization() {
    /*
     Check the video authorization status. Video access is required and audio
     access is optional. If the user denies audio access, AVCam won't
     record audio during movie recording.
     */
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
      // The user has previously granted access to the camera.
      break

    case .notDetermined:
      /* ∫
       The user has not yet been presented with the option to grant
       video access. Suspend the session queue to delay session
       setup until the access request has completed.

       Note that audio access will be implicitly requested when we
       create an AVCaptureDeviceInput for audio during session setup.
       */
      sessionQueue.suspend()
      AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
        if !granted {
          self.setupResult = .notAuthorized
        }
        self.sessionQueue.resume()
      })

    default:
      // The user has previously denied access.
      setupResult = .notAuthorized
    }
  }

  var defaultCameraType: AVCaptureDevice.DeviceType

  // var defaultCameraType: AVCaptureDevice.DeviceType = .builtInDualCamera
  var defaultCameraPostion: AVCaptureDevice.Position = .back

  ///
  @available(iOS 10.2, *)
  public func configure(captureOutputs: PBSCameraSessionOutputs,
                        captureInputs: PBSCameraSessionInputs,
                        defaultCameraType: AVCaptureDevice.DeviceType = .builtInDualCamera,
                        defaultCameraPostion: AVCaptureDevice.Position = .back) {
    checkAuthorization()
    self.defaultCameraType = defaultCameraType
    self.defaultCameraPostion = defaultCameraPostion
    sessionQueue.async {
      self.configureSession(captureOutputs: captureOutputs, captureInputs: captureInputs)
    }
  }

  /// start runing the session
  public func startRunning(notAuthorized: @escaping () -> Void,
                           configurationFailed: @escaping () -> Void,
                           isAsync: Bool = false) {
    if isAsync {
      sessionQueue.async {
        self._startRunning(notAuthorized: notAuthorized, configurationFailed: configurationFailed)
      }
    } else {
      _startRunning(notAuthorized: notAuthorized, configurationFailed: configurationFailed)
    }
  }

  /// start runing the session
  private func _startRunning(notAuthorized: @escaping () -> Void,
                             configurationFailed: @escaping () -> Void) {
    switch setupResult {
    case .success:
      captureSession.startRunning()
    case .notAuthorized:
      notAuthorized()
    case .configurationFailed:
      configurationFailed()
    }
  }

  /// stop  runing the session
  public func stopRunning(isAsync: Bool = false) {
    if isAsync {
      sessionQueue.async {
        self._stopRunning()
      }
    } else {
      _stopRunning()
    }
  }

  /// 不涉及到线程的终止session
  private func _stopRunning() {
    if setupResult == .success {
      captureSession.stopRunning()
    }
  }

  /// # cofigure session
  private func configureSession(captureOutputs: PBSCameraSessionOutputs, captureInputs: PBSCameraSessionInputs) {
    /// - Tag: ConfigureSession
    if setupResult != .success {
      return
    }

    captureSession.beginConfiguration()

    /*
     Do not create an AVCaptureMovieFileOutput when setting up the session because
     Live Photo is not supported when AVCaptureMovieFileOutput is added to the session.
     */
    captureSession.sessionPreset = .photo // captureSession.sessionPreset = .photo

    if captureInputs.contains(.videoInput) {
      if !addVideoInput() {
        captureSession.commitConfiguration()
        return
      }
    }

    if captureInputs.contains(.audioInput) {
      if !addAudioInput() {
        captureSession.commitConfiguration()
        return
      }
    }

    if captureOutputs.contains(.photoOutput) {
      if !addPhotoOutput() {
        captureSession.commitConfiguration()
        return
      }
    }

    if captureOutputs.contains(.mediaOutput) {
      if !addMediaOutput() {
        captureSession.commitConfiguration()
        return
      }
    }

    captureSession.commitConfiguration()
  }

  /// # change Camera from back to front or vise versa
  public func changeCamera() {
    guard videoDeviceInput != nil else { return }

    sessionQueue.async {
      let currentVideoDevice = self.videoDeviceInput!.device
      let currentPosition = currentVideoDevice.position

      var preferredPosition: AVCaptureDevice.Position = self.defaultCameraPostion
      var preferredDeviceType: AVCaptureDevice.DeviceType = self.defaultCameraType

      switch currentPosition {
      case .unspecified, .front:
        preferredPosition = .back
        preferredDeviceType = self.defaultCameraType

      case .back:
        preferredPosition = .front
        if #available(iOS 11.1, *) {
          preferredDeviceType = .builtInTrueDepthCamera
        }

      @unknown default:
        kLog.info(message: "Unknown capture position. Defaulting to back, dual-camera.")
        preferredPosition = .back
        preferredDeviceType = self.defaultCameraType
      }

      let devices = self.videoDeviceDiscoverySession.devices
      var newVideoDevice: AVCaptureDevice?

      // First, seek a device with both the preferred position and device type. Otherwise, seek a device with only the preferred position.
      if let device = devices.first(where: { $0.position == preferredPosition && $0.deviceType == preferredDeviceType }) {
        newVideoDevice = device
      } else if let device = devices.first(where: { $0.position == preferredPosition }) {
        newVideoDevice = device
      }

      if let videoDevice = newVideoDevice {
        do {
          let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)

          self.captureSession.beginConfiguration()

          // Remove the existing device input first, because AVCaptureSession doesn't support
          // simultaneous use of the rear and front cameras.
          self.captureSession.removeInput(self.videoDeviceInput!)

          if self.captureSession.canAddInput(videoDeviceInput) {
            self.captureSession.addInput(videoDeviceInput)
            self.videoDeviceInput = videoDeviceInput
          } else {
            self.captureSession.addInput(self.videoDeviceInput!)
          }
          if let connection = self.movieFileOutput?.connection(with: .video) {
            if connection.isVideoStabilizationSupported {
              connection.preferredVideoStabilizationMode = .auto
            }
          }

          /*
           Set Live Photo capture and depth data delivery if it's supported. When changing cameras, the
           `livePhotoCaptureEnabled` and `depthDataDeliveryEnabled` properties of the AVCapturePhotoOutput
           get set to false when a video device is disconnected from the session. After the new video device is
           added to the session, re-enable them on the AVCapturePhotoOutput, if supported.
           */
          self.photoOutput.isLivePhotoCaptureEnabled = self.photoOutput.isLivePhotoCaptureSupported
          if #available(iOS 11.0, *) {
            self.photoOutput.isDepthDataDeliveryEnabled = self.photoOutput.isDepthDataDeliverySupported
          }
          if #available(iOS 12.0, *) {
            self.photoOutput.isPortraitEffectsMatteDeliveryEnabled = self.photoOutput.isPortraitEffectsMatteDeliverySupported
          }
          if #available(iOS 13.0, *) {
            self.photoOutput.enabledSemanticSegmentationMatteTypes = self.photoOutput.availableSemanticSegmentationMatteTypes
          }
          if #available(iOS 13.0, *) {
            self.photoOutput.maxPhotoQualityPrioritization = .quality
          }

          self.captureSession.commitConfiguration()
        } catch {
          kLog.info(message: "Error occurred while creating video device input: \(error)")
        }
      }
    }
  }

  /// # 改设备的手电筒能力当前能不能用
  public var isTorchAvailable: Bool {
    guard let videoDeviceInput = videoDeviceInput else { return false }

    return videoDeviceInput.device.isTorchAvailable
  }

  /// # 开关手电筒
  public func toggleTorch() {
    guard isTorchAvailable else { return }
    guard let videoDeviceInput = videoDeviceInput else { return }

    do {
      try videoDeviceInput.device.lockForConfiguration()

      videoDeviceInput.device.torchMode = videoDeviceInput.device.torchMode == .off ? .on : .off

      videoDeviceInput.device.unlockForConfiguration()

    } catch _ as NSError {
//      kLog.verbose("device.lockForConfiguration(): \(error)")
    }
  }

  /// # 手电筒的状态
  public var torchMode: AVCaptureDevice.TorchMode {
    guard let videoDeviceInput = videoDeviceInput else { return .off }

    return videoDeviceInput.device.torchMode
  }

  ///
  public func capturePhoto() {
    guard let videoDeviceInput = videoDeviceInput else { return }

    /*
     Retrieve the video preview layer's video orientation on the main queue before
     entering the session queue. Do this to ensure that UI elements are accessed on
     the main thread and session configuration is done on the session queue.
     */
    let videoPreviewLayerOrientation = cameraPreviewView.videoPreviewLayer.connection?.videoOrientation

    sessionQueue.async {
      if let photoOutputConnection = self.photoOutput.connection(with: .video) {
        photoOutputConnection.videoOrientation = videoPreviewLayerOrientation!
      }
      var photoSettings = AVCapturePhotoSettings()

      // Capture HEIF photos when supported. Enable auto-flash and high-resolution photos.
      if #available(iOS 11.0, *) {
        if self.photoOutput.availablePhotoCodecTypes.contains(.hevc) {
          photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        }
      } else {
        photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecJPEG])
      }

      if videoDeviceInput.device.isFlashAvailable {
        photoSettings.flashMode = .auto
      }

      photoSettings.isHighResolutionPhotoEnabled = true
      if !photoSettings.__availablePreviewPhotoPixelFormatTypes.isEmpty {
        photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoSettings.__availablePreviewPhotoPixelFormatTypes.first!]
      }
      // Live Photo capture is not supported in movie mode.
      if self.livePhotoMode == .on && self.photoOutput.isLivePhotoCaptureSupported {
        let livePhotoMovieFileName = NSUUID().uuidString
        let livePhotoMovieFilePath = (NSTemporaryDirectory() as NSString).appendingPathComponent(
          (livePhotoMovieFileName as NSString).appendingPathExtension("mov")!)
        photoSettings.livePhotoMovieFileURL = URL(fileURLWithPath: livePhotoMovieFilePath)
      }

      if #available(iOS 11.0, *) {
        photoSettings.isDepthDataDeliveryEnabled = (self.depthDataDeliveryMode == .on && self.photoOutput.isDepthDataDeliveryEnabled)
      }

      if #available(iOS 12.0, *) {
        photoSettings.isPortraitEffectsMatteDeliveryEnabled = (self.portraitEffectsMatteDeliveryMode == .on
          && self.photoOutput.isPortraitEffectsMatteDeliveryEnabled)
      }

//            if #available(iOS 13.0, *) {
//                photoSettings.photoQualityPrioritization = self.photoQualityPrioritizationMode
//            }

      // The photo output holds a weak reference to the photo capture delegate and stores it in an array to maintain a strong reference.
      self.photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
  }
}

///
extension PBSCameraSessionManager {
  /// # 裁剪出区域内的照片
  public func cropToPreviewLayer(originalImage: UIImage, cropFrame: CGRect) -> UIImage? {
    guard let cgImage = originalImage.cgImage else { return nil }

    let outputRect = cameraPreviewView.videoPreviewLayer.metadataOutputRectConverted(fromLayerRect: cropFrame)

    let width = CGFloat(cgImage.width)
    let height = CGFloat(cgImage.height)
    let cropRect = CGRect(x: outputRect.origin.x * width,
                          y: outputRect.origin.y * height,
                          width: outputRect.size.width * width,
                          height: outputRect.size.height * height)

    if let croppedCGImage = cgImage.cropping(to: cropRect) {
      return UIImage(cgImage: croppedCGImage, scale: 1.0, orientation: originalImage.imageOrientation)
    }

    return nil
  }
}
