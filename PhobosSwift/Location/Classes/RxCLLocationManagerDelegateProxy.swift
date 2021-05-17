//
//
//  RxCLLocationManagerDelegateProxy.swift
//  PhobosSwiftLocation
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

import CoreLocation
import Foundation
import RxCocoa
import RxSwift

class RxCLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType {
  /// Typed parent object.
  public private(set) weak var manager: CLLocationManager?

  /// - parameter textview: Parent object for delegate proxy.
  public init(locationManager: CLLocationManager) {
    manager = locationManager
    super.init(parentObject: locationManager, delegateProxy: RxCLLocationManagerDelegateProxy.self)
  }

  public static func currentDelegate(for object: CLLocationManager) -> CLLocationManagerDelegate? {
    object.delegate
  }

  public static func setCurrentDelegate(_ delegate: CLLocationManagerDelegate?, to object: CLLocationManager) {
    object.delegate = delegate
  }

  public static func registerKnownImplementations() {
    register { RxCLLocationManagerDelegateProxy(locationManager: $0) }
  }

  private(set) var didUpdateLocationsSubject = PublishSubject<(CLLocationManager, [CLLocation])>()
  private(set) var didUpdateHeadingSubject = PublishSubject<(CLLocationManager, CLHeading)>()
  private(set) var didDetermineStateSubject = PublishSubject<(CLLocationManager, CLRegionState, CLRegion)>()
  private(set) var didRangeBeaconsSubject = PublishSubject<(CLLocationManager, [CLBeacon], CLBeaconRegion)>()

  private var _didRangeBeaconsSatisfyingBeaconConstraintSubject: Any?
  @available(iOS 13.0, *)
  var didRangeBeaconsSatisfyingBeaconConstraintSubject: PublishSubject<(CLLocationManager, [CLBeacon], CLBeaconIdentityConstraint)> {
    if _didRangeBeaconsSatisfyingBeaconConstraintSubject == nil {
      return PublishSubject<(CLLocationManager, [CLBeacon], CLBeaconIdentityConstraint)>()
    } else {
      return _didRangeBeaconsSatisfyingBeaconConstraintSubject as! PublishSubject<(CLLocationManager, [CLBeacon], CLBeaconIdentityConstraint)>
    }
  }

  private var _didFailRangingForBeaconConstraintSubject: Any?
  @available(iOS 13.0, *)
  var didFailRangingForBeaconConstraintSubject: PublishSubject<(CLLocationManager, CLBeaconIdentityConstraint, Error)> {
    if _didRangeBeaconsSatisfyingBeaconConstraintSubject == nil {
      return PublishSubject<(CLLocationManager, CLBeaconIdentityConstraint, Error)>()
    } else {
      return _didRangeBeaconsSatisfyingBeaconConstraintSubject as! PublishSubject<(CLLocationManager, CLBeaconIdentityConstraint, Error)>
    }
  }

  private(set) var rangingBeaconsDidFailForBeaconRegionSubject = PublishSubject<(CLLocationManager, CLBeaconRegion, Error)>()
  private(set) var didEnterRegionSubject = PublishSubject<(CLLocationManager, CLRegion)>()
  private(set) var didExitRegionSubject = PublishSubject<(CLLocationManager, CLRegion)>()
  private(set) var didFailWithErrorSubject = PublishSubject<(CLLocationManager, Error)>()
  private(set) var monitoringDidFailForRegionSubject = PublishSubject<(CLLocationManager, CLRegion?, Error)>()

  private var _didChangeAuthorizationSubject: Any?
  @available(iOS, introduced: 4.2, deprecated: 14.0)
  var didChangeAuthorizationSubject: PublishSubject<(CLLocationManager, CLAuthorizationStatus)> {
    if _didChangeAuthorizationSubject == nil {
      return PublishSubject<(CLLocationManager, CLAuthorizationStatus)>()
    } else {
      return _didChangeAuthorizationSubject as! PublishSubject<(CLLocationManager, CLAuthorizationStatus)>
    }
  }

  private var _locationManagerDidChangeAuthorizationSubject: Any?
  @available(iOS 14.0, *)
  var locationManagerDidChangeAuthorizationSubject: PublishSubject<CLLocationManager> {
    if _locationManagerDidChangeAuthorizationSubject == nil {
      return PublishSubject<CLLocationManager>()
    } else {
      return _locationManagerDidChangeAuthorizationSubject as! PublishSubject<CLLocationManager>
    }
  }

  private(set) var didStartMonitoringForRegionSubject = PublishSubject<(CLLocationManager, CLRegion)>()
  private(set) var locationManagerDidPauseLocationUpdatesSubject = PublishSubject<CLLocationManager>()
  private(set) var locationManagerDidResumeLocationUpdatesSubject = PublishSubject<CLLocationManager>()
  private(set) var didFinishDeferredUpdatesWithErrorSubject = PublishSubject<(CLLocationManager, Error?)>()
  private(set) var didVisitSubject = PublishSubject<(CLLocationManager, CLVisit)>()
}

// MARK: PBSWechatDelegate

extension RxCLLocationManagerDelegateProxy: CLLocationManagerDelegate {
  /// For more information take a look at `DelegateProxyType`.

  /// Invoked when new locations are available.  Required for delivery of
  /// deferred locations.  If implemented, updates will
  /// not be delivered to locationManager:didUpdateToLocation:fromLocation:
  ///
  /// locations is an array of CLLocation objects in chronological order.
  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    didUpdateLocationsSubject.onNext((manager, locations))
    _forwardToDelegate?.locationManager(manager, didUpdateLocations: locations)
  }

  /// Invoked when a new heading is available.
  public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    didUpdateHeadingSubject.onNext((manager, newHeading))
    _forwardToDelegate?.locationManager(manager, didUpdateHeading: newHeading)
  }

  /// Invoked when a new heading is available. Return YES to display heading calibration info. The display
  /// will remain until heading is calibrated, unless dismissed early via dismissHeadingCalibrationDisplay.
  ///
  /// 如果为true，是当在室内、地下、有磁场干扰或者很久没有用指南针时系统发现方向不够准确时自动弹出校准。
  public func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
    manager.pbs_shouldDisplayHeadingCalibration
  }

  /// Invoked when there's a state transition for a monitored region or in response to a request for state via a
  /// a call to requestStateForRegion:.
  public func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
    didDetermineStateSubject.onNext((manager, state, region))
    _forwardToDelegate?.locationManager(manager, didDetermineState: state, for: region)
  }

  /// Invoked when a new set of beacons are available in the specified region.
  /// beacons is an array of CLBeacon objects.
  /// If beacons is empty, it may be assumed no beacons that match the specified region are nearby.
  /// Similarly if a specific beacon no longer appears in beacons, it may be assumed the beacon is no longer received
  /// by the device.
  public func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
    didRangeBeaconsSubject.onNext((manager, beacons, region))
    _forwardToDelegate?.locationManager(manager, didRangeBeacons: beacons, in: region)
  }

  /// Invoked when an error has occurred ranging beacons in a region. Error types are defined in "CLError.h".
  public func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
    rangingBeaconsDidFailForBeaconRegionSubject.onNext((manager, region, error))
    _forwardToDelegate?.locationManager(manager, rangingBeaconsDidFailFor: region, withError: error)
  }

  @available(iOS 13.0, *)
  public func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
    didRangeBeaconsSatisfyingBeaconConstraintSubject.onNext((manager, beacons, beaconConstraint))
    _forwardToDelegate?.locationManager(manager, didRange: beacons, satisfying: beaconConstraint)
  }

  @available(iOS 13.0, *)
  public func locationManager(_ manager: CLLocationManager, didFailRangingFor beaconConstraint: CLBeaconIdentityConstraint, error: Error) {
    didFailRangingForBeaconConstraintSubject.onNext((manager, beaconConstraint, error))
    _forwardToDelegate?.locationManager(manager, didFailRangingFor: beaconConstraint, error: error)
  }

  /// Invoked when the user enters a monitored region.  This callback will be invoked for every allocated
  /// CLLocationManager instance with a non-nil delegate that implements this method.
  public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    didEnterRegionSubject.onNext((manager, region))
    _forwardToDelegate?.locationManager(manager, didEnterRegion: region)
  }

  /// Invoked when the user exits a monitored region.  This callback will be invoked for every allocated
  /// CLLocationManager instance with a non-nil delegate that implements this method.
  public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    didExitRegionSubject.onNext((manager, region))
    _forwardToDelegate?.locationManager(manager, didExitRegion: region)
  }

  /// Invoked when an error has occurred. Error types are defined in "CLError.h".
  public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    didFailWithErrorSubject.onNext((manager, error))
    _forwardToDelegate?.locationManager(manager, didFailWithError: error)
  }

  /// Invoked when a region monitoring error has occurred. Error types are defined in "CLError.h".
  public func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
    monitoringDidFailForRegionSubject.onNext((manager, region, error))
    _forwardToDelegate?.locationManager(manager, monitoringDidFailFor: region, withError: error)
  }

  /// Invoked when the authorization status changes for this application.
  @available(iOS, introduced: 4.2, deprecated: 14.0)
  public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    manager._pbs_authorizationStatus = status
    didChangeAuthorizationSubject.onNext((manager, status))
    _forwardToDelegate?.locationManager(manager, didChangeAuthorization: status)
  }

  /*
   *  locationManagerDidChangeAuthorization:
   *
   *  Discussion:
   *    Invoked when either the authorizationStatus or
   *    accuracyAuthorization properties change
   */
  @available(iOS 14.0, *)
  public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    locationManagerDidChangeAuthorizationSubject.onNext(manager)
    _forwardToDelegate?.locationManagerDidChangeAuthorization(manager)
  }

  /// Invoked when a monitoring for a region started successfully.
  public func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
    didStartMonitoringForRegionSubject.onNext((manager, region))
    _forwardToDelegate?.locationManager(manager, didStartMonitoringFor: region)
  }

  /// Invoked when location updates are automatically paused.
  public func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
    locationManagerDidPauseLocationUpdatesSubject.onNext(manager)
    _forwardToDelegate?.locationManagerDidPauseLocationUpdates(manager)
  }

  /// Invoked when location updates are automatically resumed.
  ///
  /// In the event that your application is terminated while suspended, you will not receive this notification.
  public func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
    locationManagerDidResumeLocationUpdatesSubject.onNext(manager)
    _forwardToDelegate?.locationManagerDidResumeLocationUpdates(manager)
  }

  /// Invoked when deferred updates will no longer be delivered. Stopping
  /// location, disallowing deferred updates, and meeting a specified criterion
  /// are all possible reasons for finishing deferred updates.
  ///
  /// An error will be returned if deferred updates end before the specified
  /// criteria are met (see CLError), otherwise error will be nil.
  public func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
    didFinishDeferredUpdatesWithErrorSubject.onNext((manager, error))
    _forwardToDelegate?.locationManager(manager, didFinishDeferredUpdatesWithError: error)
  }

  /// Invoked when the CLLocationManager determines that the device has visited
  /// a location, if visit monitoring is currently started (possibly from a
  /// prior launch).
  public func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
    didVisitSubject.onNext((manager, visit))
    _forwardToDelegate?.locationManager(manager, didVisit: visit)
  }
}
