//
//
//  PBSImageFilterTest.swift
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

class PBSImageFilterTest: QuickSpec {
  override func spec() {
    testRender()
    testGetCubeData()
    testFilter()
    testBoomEffect()
    testRGBToHSV()
    testHSVToRGB()
  }
  
  func testRender() {
    describe("Given 有一个空的图片，tintColor为白色") {
      let emptyImage = UIImage()
      let tintColor = UIColor.white
      context("When 调用PBSImageFilter.render") {
        let resultImage = PBSImageFilter.render(image: emptyImage, with: tintColor)
        it("Then 返回nil") {
          expect(resultImage).to(beNil())
        }
      }
    }
  }
  
  func testGetCubeData() {
    describe("Given size为2，tintColor为白色") {
      let size = 2
      let tintColor = UIColor.white
      let expectArray: [Float] = [1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      
      context("When 调用PBSImageFilter.getCubeData") {
        let resultArray = PBSImageFilter.getCubeData(size: size, with: tintColor)
        it("Then 返回\(expectArray)") {
          expect(resultArray).to(equal(expectArray))
        }
      }
    }
  }
  
  func testFilter() {
    describe("Given 提供空的图片") {
      let cuteData: [Float] = []
      let size = 0
      let image = UIImage()
      
      context("When 调用PBSImageFilter.filter") {
        let resultImage = PBSImageFilter.filter(with: cuteData, size: size, image: image)
        it("Then 返回nil") {
          expect(resultImage).to(beNil())
        }
      }
    }
  }
  
  func testBoomEffect() {
    describe("Given 提供空的图片") {
      let image = CIImage()
      context("When 调用PBSImageFilter.boomEffect") {
        let resultImage = PBSImageFilter.boomEffect(with: image)
        it("Then 返回不为nil") {
          expect(resultImage).toNot(beNil())
        }
      }
    }
  }
  
  func testRGBToHSV() {
    describe("Given 一个颜色为RGB(123, 123, 123)") {
      let color: (r: Float, g: Float, b: Float) = (r: 123, g: 123, b: 123)
      let expectColor: (h: Float, s: Float, v: Float) = (h: 0, s: 0, v: 123)
      
      context("When 调用PBSImageFilter.RGBToHSV") {
        let result = PBSImageFilter.RGBToHSV(color.r, g: color.g, b: color.b)
        it("Then 返回的结果为\(expectColor)") {
          expect(result).to(equal(expectColor))
        }
      }
    }
  }
  
  func testHSVToRGB() {
    describe("Given 一个颜色为HSV(0, 0, 123)") {
      let color: (h: Float, s: Float, v: Float) = (h: 0, s: 0, v: 123)
      let expectColor: (r: Float, g: Float, b: Float) = (r: 123, g: 123, b: 123)
      
      context("When 调用PBSImageFilter.HSVToRGB") {
        let result = PBSImageFilter.HSVToRGB(color.h, s: color.s, v: color.v)
        it("Then 返回的结果为\(expectColor)") {
          expect(result).to(equal(expectColor))
        }
      }
    }
  }
}
