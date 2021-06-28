// Copyright 2018-Present Shin Yamamoto. All rights reserved. MIT license.

import UIKit

/// A view that presents a grabber handle in the surface of a panel.
@objc(FloatingPanelGrabberView)
public class FloatingPanelGrabberView: UIView {
  public var barColor = UIColor(displayP3Red: 0.76, green: 0.77, blue: 0.76, alpha: 1.0) { didSet { backgroundColor = barColor } }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  init() {
    super.init(frame: .zero)
    backgroundColor = barColor
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    render()
  }

  override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let view = super.hitTest(point, with: event)
    return view == self ? nil : view
  }

  private func render() {
    layer.masksToBounds = true
  }
}
