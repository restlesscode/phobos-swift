//
//
//  Annotation.swift
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

import MapKit

open class Annotation: NSObject, MKAnnotation {
  open var style: ClusterAnnotationStyle?
  open var coordinate: CLLocationCoordinate2D

  public init(coordinate: CLLocationCoordinate2D) {
    self.coordinate = coordinate
    super.init()
  }
}

open class ClusterAnnotation: Annotation {
  open var annotations = [MKAnnotation]()

  override open func isEqual(_ object: Any?) -> Bool {
    guard let object = object as? ClusterAnnotation else { return false }

    if self === object {
      return true
    }

    if coordinate != object.coordinate {
      return false
    }

    if annotations.count != object.annotations.count {
      return false
    }

    return annotations.map { $0.coordinate } == object.annotations.map { $0.coordinate }
  }
}

/**
 The view associated with your cluster annotations.
 */
open class ClusterAnnotationView: MKAnnotationView {
  open lazy var countLabel: UILabel = {
    let label = UILabel()
    label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    label.backgroundColor = .clear
    label.font = .boldSystemFont(ofSize: 13)
    label.textColor = .white
    label.textAlignment = .center
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    label.baselineAdjustment = .alignCenters
    self.addSubview(label)
    return label
  }()

  override open var annotation: MKAnnotation? {
    didSet {
      configure()
    }
  }

  open func configure() {
    guard let annotation = annotation as? ClusterAnnotation else { return }
    let count = annotation.annotations.count
    countLabel.text = "\(count)"
  }
}

/**
 The style of the cluster annotation view.
 */
public enum ClusterAnnotationStyle {
  /**
   Displays the annotations as a circle.

   - `color`: The color of the annotation circle
   - `radius`: The radius of the annotation circle
   */
  case color(UIColor, radius: CGFloat)

  /**
   Displays the annotation as an image.
   */
  case image(UIImage?)
}

/**
 A cluster annotation view that supports styles.
 */
open class StyledClusterAnnotationView: ClusterAnnotationView {
  /**
   The style of the cluster annotation view.
   */
  public var style: ClusterAnnotationStyle

  /**
   Initializes and returns a new cluster annotation view.

   - Parameters:
   - annotation: The annotation object to associate with the new view.
   - reuseIdentifier: If you plan to reuse the annotation view for similar types of annotations, pass a string to identify it. Although you can pass nil if you do not intend to reuse the view, reusing annotation views is generally recommended.
   - style: The cluster annotation style to associate with the new view.

   - Returns: The initialized cluster annotation view.
   */
  public init(annotation: MKAnnotation?, reuseIdentifier: String?, style: ClusterAnnotationStyle) {
    self.style = style
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    configure()
  }

  @available(*, unavailable)
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override open func configure() {
    guard let annotation = annotation as? ClusterAnnotation else { return }

    switch style {
    case let .image(image):
      backgroundColor = .clear
      self.image = image
    case let .color(color, radius):
      let count = annotation.annotations.count
      backgroundColor = color
      var diameter = radius * 2
      switch count {
      case _ where count < 8:
        diameter *= 0.6
      case _ where count < 16:
        diameter *= 0.8
      default: break
      }
      frame = CGRect(origin: frame.origin, size: CGSize(width: diameter, height: diameter))
      countLabel.text = "\(count)"
    }
  }

  override open func layoutSubviews() {
    super.layoutSubviews()

    if case .color = style {
      layer.masksToBounds = true
      layer.cornerRadius = image == nil ? bounds.width / 2 : 0
      countLabel.frame = bounds
    }
  }
}
