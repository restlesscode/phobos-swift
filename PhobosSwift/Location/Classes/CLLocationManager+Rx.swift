//
//
//  CLLocationManager+Rx.swift
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

extension Reactive where Base: CLLocationManager {
  /// DelegateProxy for PBSWechatDelegate
  public var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
    RxCLLocationManagerDelegateProxy.proxy(for: base)
  }

  /// Reactive wrapper for delegate method `didUpdateLocations`
  public var didUpdateLocations: ControlEvent<(CLLocationManager, [CLLocation])> {
    let source = RxCLLocationManagerDelegateProxy.proxy(for: base).didUpdateLocationsSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didUpdateHeading`
  public var didUpdateHeading: ControlEvent<(CLLocationManager, CLHeading)> {
    let source = RxCLLocationManagerDelegateProxy.proxy(for: base).didUpdateHeadingSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didDetermineState`
  public var didDetermineState: ControlEvent<(CLLocationManager, CLRegionState, CLRegion)> {
    let source = RxCLLocationManagerDelegateProxy.proxy(for: base).didDetermineStateSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didRangeBeacons`
  public var didRangeBeacons: ControlEvent<(CLLocationManager, [CLBeacon], CLBeaconRegion)> {
    let source = RxCLLocationManagerDelegateProxy.proxy(for: base).didRangeBeaconsSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didRangeBeaconsSatisfyingBeaconConstraint`
  @available(iOS 13.0, *)
  public var didRangeBeaconsSatisfyingBeaconConstraint: ControlEvent<(CLLocationManager, [CLBeacon], CLBeaconIdentityConstraint)> {
    let source = RxCLLocationManagerDelegateProxy.proxy(for: base).didRangeBeaconsSatisfyingBeaconConstraintSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didFailRangingForBeaconConstraint`
  @available(iOS 13.0, *)
  public var didFailRangingForBeaconConstraint: ControlEvent<(CLLocationManager, CLBeaconIdentityConstraint, Error)> {
    let source = RxCLLocationManagerDelegateProxy.proxy(for: base).didFailRangingForBeaconConstraintSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `rangingBeaconsDidFailForBeaconRegion`
  public var rangingBeaconsDidFailForBeaconRegion: ControlEvent<(CLLocationManager, CLBeaconRegion, Error)> {
    let source = RxCLLocationManagerDelegateProxy.proxy(for: base).rangingBeaconsDidFailForBeaconRegionSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didEnterRegion`
  public var didEnterRegion: ControlEvent<(CLLocationManager, CLRegion)> {
    let source = RxCLLocationManagerDelegateProxy.proxy(for: base).didEnterRegionSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didExitRegion`
  public var didExitRegion: ControlEvent<(CLLocationManager, CLRegion)> {
    let source = RxCLLocationManagerDelegateProxy.proxy(for: base).didExitRegionSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didFailWithError`
  public var didFailWithError: ControlEvent<(CLLocationManager, Error)> {
    let source = RxCLLocationManagerDelegateProxy.proxy(for: base).didFailWithErrorSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `monitoringDidFailForRegion`
  public var monitoringDidFailForRegion: ControlEvent<(CLLocationManager, CLRegion?, Error)> {
    let source = RxCLLocationManagerDelegateProxy.proxy(for: base).monitoringDidFailForRegionSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didChangeAuthorization`
  @available(iOS, introduced: 4.2, deprecated: 14.0)
  public var didChangeAuthorization: ControlEvent<(CLLocationManager, CLAuthorizationStatus)> {
    let source = RxCLLocationManagerDelegateProxy.proxy(for: base).didChangeAuthorizationSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `locationManagerDidChangeAuthorization`
  @available(iOS 14.0, *)
  public var locationManagerDidChangeAuthorization: ControlEvent<CLLocationManager> {
    let source = RxCLLocationManagerDelegateProxy.proxy(for: base).locationManagerDidChangeAuthorizationSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didStartMonitoringForRegion`
  public var didStartMonitoringForRegion: ControlEvent<(CLLocationManager, CLRegion)> {
    let source = RxCLLocationManagerDelegateProxy.proxy(for: base).didStartMonitoringForRegionSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `locationManagerDidPauseLocationUpdates`
  public var locationManagerDidPauseLocationUpdates: ControlEvent<CLLocationManager> {
    let source = RxCLLocationManagerDelegateProxy.proxy(for: base).locationManagerDidPauseLocationUpdatesSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `locationManagerDidResumeLocationUpdates`
  public var locationManagerDidResumeLocationUpdates: ControlEvent<CLLocationManager> {
    let source = RxCLLocationManagerDelegateProxy.proxy(for: base).locationManagerDidResumeLocationUpdatesSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didFinishDeferredUpdatesWithError`
  public var didFinishDeferredUpdatesWithError: ControlEvent<(CLLocationManager, Error?)> {
    let source = RxCLLocationManagerDelegateProxy.proxy(for: base).didFinishDeferredUpdatesWithErrorSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didVisit`
  public var didVisit: ControlEvent<(CLLocationManager, CLVisit)> {
    let source = RxCLLocationManagerDelegateProxy.proxy(for: base).didVisitSubject
    return ControlEvent(events: source)
  }

  /// Installs delegate as forwarding delegate on `delegate`.
  /// Delegate won't be retained.
  ///
  /// It enables using normal delegate mechanism with reactive delegate mechanism.
  ///
  /// - parameter delegate: Delegate object.
  /// - returns: Disposable object that can be used to unbind the delegate.
  public func setDelegate(_ delegate: CLLocationManagerDelegate)
    -> Disposable {
    RxCLLocationManagerDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: base)
  }
}
