//
//
//  PhobosSwiftLocation.swift
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

import Foundation
import MapKit
import PhobosSwiftLog

extension Bundle {
  static var bundle: Bundle {
    Bundle.pbs.bundle(with: PhobosSwiftLocation.self)
  }
}

extension String {
  var localized: String {
    pbs.localized(inBundle: Bundle.bundle)
  }
}

extension PBSLogger {
  static let logger = PBSLogger.shared
}

enum Constants {
  enum Text {
    static let kSettings = "SETTINGS".localized
    static let kCancel = "CANCEL".localized
    static let kAllowLocationAccess = "ALLOW_LOCATION_ACCESS".localized
    static let kAllowLocationAccessMessage = "ALLOW_LOCATION_ACCESS_MESSAGE".localized
  }
}

extension MKMapRect {
  init(minX: Double, minY: Double, maxX: Double, maxY: Double) {
    self.init(x: minX, y: minY, width: abs(maxX - minX), height: abs(maxY - minY))
  }

  init(x: Double, y: Double, width: Double, height: Double) {
    self.init(origin: MKMapPoint(x: x, y: y), size: MKMapSize(width: width, height: height))
  }

  func contains(_ coordinate: CLLocationCoordinate2D) -> Bool {
    contains(MKMapPoint(coordinate))
  }
}

extension CLLocationCoordinate2D: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(latitude)
    hasher.combine(longitude)
  }
}

///
public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
  lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}

let CLLocationCoordinate2DMax = CLLocationCoordinate2D(latitude: 90, longitude: 180)
let MKMapPointMax = MKMapPoint(CLLocationCoordinate2DMax)

extension Double {
  var zoomLevel: Double {
    let maxZoomLevel = log2(MKMapSize.world.width / 256) // 20
    let zoomLevel = floor(log2(self) + 0.5) // negative
    return max(0, maxZoomLevel + zoomLevel) // max - current
  }
}

private let radiusOfEarth: Double = 6_372_797.6

extension CLLocationCoordinate2D {
  func coordinate(onBearingInRadians bearing: Double, atDistanceInMeters distance: Double) -> CLLocationCoordinate2D {
    let distRadians = distance / radiusOfEarth // earth radius in meters

    let lat1 = latitude * .pi / 180
    let lon1 = longitude * .pi / 180

    let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearing))
    let lon2 = lon1 + atan2(sin(bearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))

    return CLLocationCoordinate2D(latitude: lat2 * 180 / .pi, longitude: lon2 * 180 / .pi)
  }

  var location: CLLocation {
    CLLocation(latitude: latitude, longitude: longitude)
  }

  func distance(from coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
    location.distance(from: coordinate.location)
  }
}

extension Array where Element: MKAnnotation {
  func subtracted(_ other: [Element]) -> [Element] {
    filter { item in !other.contains { $0.isEqual(item) } }
  }

  mutating func subtract(_ other: [Element]) {
    self = subtracted(other)
  }

  mutating func add(_ other: [Element]) {
    append(contentsOf: other)
  }

  @discardableResult
  mutating func remove(_ item: Element) -> Element? {
    firstIndex { $0.isEqual(item) }.map { remove(at: $0) }
  }
}

extension MKPolyline {
  convenience init(mapRect: MKMapRect) {
    let points = [MKMapPoint(x: mapRect.minX, y: mapRect.minY),
                  MKMapPoint(x: mapRect.maxX, y: mapRect.minY),
                  MKMapPoint(x: mapRect.maxX, y: mapRect.maxY),
                  MKMapPoint(x: mapRect.minX, y: mapRect.maxY),
                  MKMapPoint(x: mapRect.minX, y: mapRect.minY)]
    self.init(points: points, count: points.count)
  }
}

extension OperationQueue {
  static var serial: OperationQueue {
    let queue = OperationQueue()
    queue.name = "com.cluster.serialQueue"
    queue.maxConcurrentOperationCount = 1
    return queue
  }

  func addBlockOperation(_ block: @escaping (BlockOperation) -> Void) {
    let operation = BlockOperation()
    operation.addExecutionBlock { [weak operation] in
      guard let operation = operation else { return }
      block(operation)
    }
    addOperation(operation)
  }
}

extension UIImage {
  func filled(with color: UIColor) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    color.setFill()
    guard let context = UIGraphicsGetCurrentContext() else { return self }
    context.translateBy(x: 0, y: size.height)
    context.scaleBy(x: 1.0, y: -1.0)
    context.setBlendMode(CGBlendMode.normal)
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    guard let mask = cgImage else { return self }
    context.clip(to: rect, mask: mask)
    context.fill(rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
  }

  static let pin = UIImage(named: "pin")?.filled(with: .green)
  static let pin2 = UIImage(named: "pin2")?.filled(with: .green)
  static let me = UIImage(named: "me")?.filled(with: .blue)
}

extension UIColor {
  class var green: UIColor { UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1) }
  class var blue: UIColor { UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1) }
}

extension MKMapView {
  ///
  public func annotationView<T: MKAnnotationView>(of type: T.Type, annotation: MKAnnotation?, reuseIdentifier: String) -> T {
    guard let annotationView = dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? T else {
      return type.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    annotationView.annotation = annotation
    return annotationView
  }
}

class PhobosSwiftLocation: NSObject {}
