//
//
//  StringUITest.swift
//  PhobosSwiftCore-Unit-Tests
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

@testable import PhobosSwiftCore
import Nimble
import Quick

class StringUITest: QuickSpec {
  override func spec() {
    testHeight()
    testWidth()
    testHeightInNSAttributedString()
    testWidthInNSAttributedString()
  }

  func testHeight() {
    describe("Given 字符串：我爱我的祖国，我爱我的家*2，宽度100，字体16") {
      let string = "我爱我的祖国，我爱我的家，我爱我的祖国，我爱我的家"
      let width: CGFloat = 100
      let font = UIFont.systemFont(ofSize: 16)
      let expectHeight: CGFloat = 96

      context("When 调用string.pbs.height") {
        let height = string.pbs.height(withConstrainedWidth: width, font: font)
        it("Then 返回的高度为\(expectHeight)") {
          expect(height).to(equal(expectHeight))
        }
      }
    }
  }

  func testWidth() {
    describe("Given 字符串：我爱我的祖国，我爱我的家*2，高度100，字体16") {
      let string = "我爱我的祖国，我爱我的家，我爱我的祖国，我爱我的家"
      let height: CGFloat = 100
      let font = UIFont.systemFont(ofSize: 16)
      let expectWidth: CGFloat = 408

      context("When 调用string.pbs.width") {
        let width = string.pbs.width(withConstrainedHeight: height, font: font)
        it("Then 返回的宽度为\(expectWidth)") {
          expect(width).to(equal(expectWidth))
        }
      }
    }
  }

  func testHeightInNSAttributedString() {
    describe("Given 字符串：我爱我的祖国，我爱我的家*2，宽度100") {
      let string = "我爱我的祖国，我爱我的家，我爱我的祖国，我爱我的家"
      let attrString = NSMutableAttributedString(string: string)
      attrString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 0, length: string.count))
      let width: CGFloat = 100
      let expectHeight: CGFloat = 96

      context("When 调用string.pbs.height") {
        let height = (attrString as NSAttributedString).pbs.height(withConstrainedWidth: width)
        it("Then 返回的高度为\(expectHeight)") {
          expect(height).to(equal(expectHeight))
        }
      }
    }
  }

  func testWidthInNSAttributedString() {
    describe("Given 字符串：我爱我的祖国，我爱我的家*2，高度100，字体16") {
      let string = "我爱我的祖国，我爱我的家，我爱我的祖国，我爱我的家"
      let attrString = NSMutableAttributedString(string: string)
      attrString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 0, length: string.count))
      let height: CGFloat = 100
      let expectWidth: CGFloat = 408

      context("When 调用string.pbs.width") {
        let width = (attrString as NSAttributedString).pbs.width(withConstrainedHeight: height)
        it("Then 返回的宽度为\(expectWidth)") {
          expect(width).to(equal(expectWidth))
        }
      }
    }
  }
}
