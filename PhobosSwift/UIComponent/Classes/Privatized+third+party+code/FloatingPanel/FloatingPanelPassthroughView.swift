// Copyright 2018-Present Shin Yamamoto. All rights reserved. MIT license.

import UIKit

@objc(FloatingPanelPassthroughView)
class FloatingPanelPassthroughView: UIView {
  public weak var eventForwardingView: UIView?
  override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let hitView = super.hitTest(point, with: event)
    switch hitView {
    case self:
      return eventForwardingView?.hitTest(convert(point, to: eventForwardingView), with: event)
    default:
      return hitView
    }
  }
}
