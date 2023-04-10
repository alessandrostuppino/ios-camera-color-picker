//
//  Camera Colour Picker
//

import SwiftUI

struct PickedColor: Identifiable, Equatable {
  let id = UUID()
  let created = Date()
  
  var color: Color
  
  init(_ color: Color) {
    self.color = color
  }
}
