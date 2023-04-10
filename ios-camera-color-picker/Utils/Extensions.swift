//
//  Camera Colour Picker
//

import CoreGraphics
import SwiftUI
import VideoToolbox

extension String {
  /// Returns the localization for a given string `self` representing the localization key.
  var localized: String {
    NSLocalizedString(self, comment: "\(self)_comment")
  }
}

extension Text {
  /// Creates a Text component for a given localized string key.
  /// - Parameter localizable: The key of the localized string.
  init(localizable: String) {
    self.init(localizable.localized)
  }
}

extension CGImage {
  /// Creates a `CGImage` from the given `cvPixelBuffer`.
  /// - Parameter cvPixelBuffer: The buffer in output from the capture session.
  /// - Returns: The image converted from the given buffer.
  static func create(from cvPixelBuffer: CVPixelBuffer?) -> CGImage? {
    guard let pixelBuffer = cvPixelBuffer else {
      return nil
    }
    
    var image: CGImage?
    
    VTCreateCGImageFromCVPixelBuffer(
      pixelBuffer,
      options: nil,
      imageOut: &image
    )
    
    return image
  }
  
  /// The color picked from the middle point of the image. Is `nil` when the data provider of the image is `nil`.
  var middlePixelColor: UIColor? {
    guard let dataProvider = self.dataProvider,
          let pixelData = dataProvider.data else {
      return nil
    }
    
    let pos = CGPoint(x: self.width/2, y: self.height/2)
    let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
    let pixelInfo: Int = ((Int(self.width) * Int(pos.y)) + Int(pos.x)) * 4
    
    let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
    let g = CGFloat(data[pixelInfo + 1]) / CGFloat(255.0)
    let b = CGFloat(data[pixelInfo + 2]) / CGFloat(255.0)
    let a = CGFloat(data[pixelInfo + 3]) / CGFloat(255.0)
    
    return UIColor(red: r, green: g, blue: b, alpha: a)
  }
}

extension Color {
  /// Determines the brightness of the color based on its RGB components.
  var brightness: CGFloat {
    guard let components = cgColor?.components else { return 0 }
    
    return ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
  }
  
  /// Determines whether the color is light or not.
  /// It returns `nil` for a dynamic color, like one you load from an Asset Catalog using init(_:bundle:), or one you create from a dynamic UIKit or AppKit color.
  var isLight: Bool? {
    brightness >= 0.5
  }
  
  /// Creates a color for a given hexadecimal code.
  /// - Parameter hex: The hexadecimal of the requested color.
  ///                  Can contain `#` character and can be composed by 6 or 8 couples based on the alpha component
  init?(hex: String) {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
    
    var rgb: UInt64 = 0
    
    var r: CGFloat = 0.0
    var g: CGFloat = 0.0
    var b: CGFloat = 0.0
    var a: CGFloat = 1.0
    
    let length = hexSanitized.count
    
    guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
    
    if length == 6 {
      r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
      g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
      b = CGFloat(rgb & 0x0000FF) / 255.0
    } else if length == 8 {
      r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
      g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
      b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
      a = CGFloat(rgb & 0x000000FF) / 255.0
    } else {
      return nil
    }
    
    self.init(red: r, green: g, blue: b, opacity: a)
  }
  
  /// The hexadecimal of the current color.
  var hex: String? {
    let uiColor = UIColor(self)
    guard let components = uiColor.cgColor.components, components.count >= 3 else {
      return nil
    }
    let r = Float(components[0])
    let g = Float(components[1])
    let b = Float(components[2])
    var a = Float(1.0)
    
    if components.count >= 4 {
      a = Float(components[3])
    }
    
    if a != Float(1.0) {
      return String(format: "#%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
    } else {
      return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
  }
}

extension Array {
  func slice(_ range: ClosedRange<Int>) -> Array {
    guard !isEmpty, count > 1 else { return self }
    let maxIndex = count - 1
    
    if let max = range.max() {
      if maxIndex >= max {
        return Array(self[range])
      }
      
      if maxIndex > 0 {
        return Array(self[0...maxIndex])
      }
    }
    
    return []
  }
}
