//
//
//  PBSQuadTreeNode.swift
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

class PBSQuadTreeNode {
  enum NodeType {
    case leaf
    case `internal`(children: Children)
  }

  struct Children: Sequence {
    let northWest: PBSQuadTreeNode
    let northEast: PBSQuadTreeNode
    let southWest: PBSQuadTreeNode
    let southEast: PBSQuadTreeNode

    init(parentNode: PBSQuadTreeNode) {
      let mapRect = parentNode.rect
      northWest = PBSQuadTreeNode(rect: MKMapRect(minX: mapRect.minX, minY: mapRect.minY, maxX: mapRect.midX, maxY: mapRect.midY))
      northEast = PBSQuadTreeNode(rect: MKMapRect(minX: mapRect.midX, minY: mapRect.minY, maxX: mapRect.maxX, maxY: mapRect.midY))
      southWest = PBSQuadTreeNode(rect: MKMapRect(minX: mapRect.minX, minY: mapRect.midY, maxX: mapRect.midX, maxY: mapRect.maxY))
      southEast = PBSQuadTreeNode(rect: MKMapRect(minX: mapRect.midX, minY: mapRect.midY, maxX: mapRect.maxX, maxY: mapRect.maxY))
    }

    struct ChildrenIterator: IteratorProtocol {
      private var index = 0
      private let children: Children

      init(children: Children) {
        self.children = children
      }

      mutating func next() -> PBSQuadTreeNode? {
        defer { index += 1 }
        switch index {
        case 0: return children.northWest
        case 1: return children.northEast
        case 2: return children.southWest
        case 3: return children.southEast
        default: return nil
        }
      }
    }

    public func makeIterator() -> ChildrenIterator {
      ChildrenIterator(children: self)
    }
  }

  var annotations = [MKAnnotation]()
  let rect: MKMapRect
  var type: NodeType = .leaf

  static let maxPointCapacity = 8

  init(rect: MKMapRect) {
    self.rect = rect
  }
}

extension PBSQuadTreeNode: AnnotationsContainer {
  @discardableResult
  func add(_ annotation: MKAnnotation) -> Bool {
    guard rect.contains(annotation.coordinate) else { return false }

    switch type {
    case .leaf:
      annotations.append(annotation)
      // if the max capacity was reached, become an internal node
      if annotations.count == PBSQuadTreeNode.maxPointCapacity {
        subdivide()
      }
    case let .internal(children):
      // pass the point to one of the children
      for child in children where child.add(annotation) {
        return true
      }

      assertionFailure("rect.contains evaluted to true, but none of the children added the annotation")
    }
    return true
  }

  @discardableResult
  func remove(_ annotation: MKAnnotation) -> Bool {
    guard rect.contains(annotation.coordinate) else { return false }

    _ = annotations.map { $0.coordinate }.firstIndex(of: annotation.coordinate).map { annotations.remove(at: $0) }

    switch type {
    case .leaf: break
    case let .internal(children):
      // pass the point to one of the children
      for child in children where child.remove(annotation) {
        return true
      }

      assertionFailure("rect.contains evaluted to true, but none of the children removed the annotation")
    }
    return true
  }

  private func subdivide() {
    switch type {
    case .leaf:
      type = .internal(children: Children(parentNode: self))
    case .internal:
      preconditionFailure("Calling subdivide on an internal node")
    }
  }

  func annotations(in rect: MKMapRect) -> [MKAnnotation] {
    guard self.rect.intersects(rect) else { return [] }

    var result = [MKAnnotation]()

    for annotation in annotations where rect.contains(annotation.coordinate) {
      result.append(annotation)
    }

    switch type {
    case .leaf: break
    case let .internal(children):
      for childNode in children {
        result.append(contentsOf: childNode.annotations(in: rect))
      }
    }

    return result
  }
}
