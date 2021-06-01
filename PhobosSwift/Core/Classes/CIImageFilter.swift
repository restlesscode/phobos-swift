//
//
//  CIImageFilter.swift
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

import Foundation

public struct CIImageFilter {
  public static let cubeFilter = FilterModel(with: .cube)
  static let size = 64

  public static func render(image: UIImage, with tintColor: UIColor) -> UIImage? {
    let cubeData = getCubeData(size: size, with: tintColor)
    if let filter = Self.filter(with: cubeData, size: size, image: image) {
      return UIImage(ciImage: filter)
    } else {
      return nil
    }
  }

  public static func getCubeData(size: Int, with tintColor: UIColor) -> [Float] {
    var cubeData = [Float](repeating: 0, count: size * size * size * 4)
    var rgb: [Float] = [0, 0, 0]
    var hsv: (h: Float, s: Float, v: Float)
    var tint: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)
    tintColor.getRed(&tint.r, green: &tint.g, blue: &tint.b, alpha: &tint.a)
    var offset = 0
    for z in 0..<size {
      rgb[2] = Float(z) / Float(size) // blue value
      for y in 0..<size {
        rgb[1] = Float(y) / Float(size) // green value
        for x in 0..<size {
          rgb[0] = Float(x) / Float(size) // red value
          hsv = RGBToHSV(rgb[0], g: rgb[1], b: rgb[2])
          if hsv.v == 0 {
            // replace black color with tint color
            cubeData[offset] = Float(tint.r)
            cubeData[offset + 1] = Float(tint.g)
            cubeData[offset + 2] = Float(tint.b)
            cubeData[offset + 3] = 1
          } else {
            cubeData[offset] = 0
            cubeData[offset + 1] = 0
            cubeData[offset + 2] = 0
            cubeData[offset + 3] = 0
          }
          offset += 4
        }
      }
    }
    return cubeData
  }

  public static func filter(with cubeData: [Float], size: Int, image: UIImage, model: FilterModel = Self.cubeFilter) -> CIImage? {
    let ciImage = CIImage(image: image)
    let data = cubeData.withUnsafeBufferPointer { Data(buffer: $0) }
    if let cubeFilter = CIFilter(name: model.name) {
      cubeFilter.setValue(size, forKey: model.sizeKey)
      cubeFilter.setValue(data, forKey: model.dataKey)
      cubeFilter.setValue(ciImage, forKey: kCIInputImageKey)
      return cubeFilter.outputImage
//            return boomEffect(with: cubeFilter.outputImage)
    }
    return nil
  }

  public static func boomEffect(with image: CIImage?) -> CIImage? {
    let mode = FilterModel(with: .bloom)
    if let bloomFilter = CIFilter(name: mode.name), let ciImage = image {
      bloomFilter.setValue(ciImage, forKey: kCIInputImageKey)
      bloomFilter.setValue(0.1, forKey: mode.dataKey)
      bloomFilter.setValue(8, forKey: mode.sizeKey)
      return bloomFilter.outputImage
    }
    return nil
  }

  public struct FilterModel {
    private let cubeDimensionKey = "inputCubeDimension"
    private let cubeDataKey = "inputCubeData"

    public enum FilterType: String {
      case cube = "CIColorCube"
      case bloom = "CIBloom"
    }

    private let type: FilterType
    public let sizeKey: String
    public let dataKey: String
    public let name: String

    public init(with type: FilterType) {
      self.type = type
      switch type {
      case .cube:
        sizeKey = cubeDimensionKey
        dataKey = cubeDataKey
        name = type.rawValue
      case .bloom:
        sizeKey = kCIInputIntensityKey
        dataKey = kCIInputRadiusKey
        name = type.rawValue
      }
    }
  }
}

extension CIImageFilter {
  public static func RGBToHSV(_ r: Float, g: Float, b: Float) -> (h: Float, s: Float, v: Float) {
    var h: CGFloat = 0
    var s: CGFloat = 0
    var v: CGFloat = 0
    let col = UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
    col.getHue(&h, saturation: &s, brightness: &v, alpha: nil)
    return (Float(h), Float(s), Float(v))
  }

  public static func HSVToRGB(_ h: Float, s: Float, v: Float) -> (r: Float, g: Float, b: Float) {
    var r: Float = 0
    var g: Float = 0
    var b: Float = 0
    let C = s * v
    let HS = h * 6.0
    let X = C * (1.0 - fabsf(fmodf(HS, 2.0) - 1.0))
    if HS >= 0 && HS < 1 {
      r = C
      g = X
      b = 0
    } else if HS >= 1 && HS < 2 {
      r = X
      g = C
      b = 0
    } else if HS >= 2 && HS < 3 {
      r = 0
      g = C
      b = X
    } else if HS >= 3 && HS < 4 {
      r = 0
      g = X
      b = C
    } else if HS >= 4 && HS < 5 {
      r = X
      g = 0
      b = C
    } else if HS >= 5 && HS < 6 {
      r = C
      g = 0
      b = X
    }
    let m = v - C
    r += m
    g += m
    b += m
    return (r, g, b)
  }
}
