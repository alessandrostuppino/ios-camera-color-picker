//
//  Camera Colour Picker
//

import SwiftUI

struct Constants {
  static let kPickedColors = "pickedColors"
  static let pickedColorsSeparator = ","
  
  struct Manager {
    static let frameVideoOutputQueueLabel = "cameraColorPicker.videoOutputQueue"
    static let cameraSessionQueueLabel = "cameraColorPicker.sessionQueue"
  }
  
  struct Images {
    static let pickColor = Image(systemName: "plus.app.fill")
    static let enabledFlash = Image(systemName: "bolt.fill")
    static let disabledFlash = Image(systemName: "bolt.slash.fill")
    static let more = Image(systemName: "ellipsis")
    static let copy = Image(systemName: "doc.on.doc")
    static let delete = Image(systemName: "trash")
    static let close = Image(systemName: "multiply")
    static let filter = Image(systemName: "line.3.horizontal.decrease.circle")
  }
}
