//
//
//  ModalView.swift
//  PhobosSwiftCore
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

import SwiftUI

@available(iOS 13.0, *)
public struct ModalView<SomeView>: UIViewControllerRepresentable where SomeView: View {
  public var content: () -> SomeView

  public let onAttemptToDismiss: (() -> Void)?

  public let allowDragDismiss: Bool

  public init(content: @escaping (() -> SomeView), onAttemptToDismiss: (() -> Void)?, allowDragDismiss: Bool) {
    self.content = content
    self.onAttemptToDismiss = onAttemptToDismiss
    self.allowDragDismiss = allowDragDismiss
  }

  public func makeUIViewController(context: Context) -> UIViewController {
    UIHostingController(rootView: content())
  }

  public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    uiViewController.parent?.presentationController?.delegate = context.coordinator
  }

  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  public class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
    let modalView: ModalView

    init(_ modalView: ModalView) {
      self.modalView = modalView
    }

    public func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
      modalView.allowDragDismiss
    }

    public func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
      modalView.onAttemptToDismiss?()
    }
  }
}
