//
//  Camera Colour Picker
//

import SwiftUI

struct DragRelocateDelegate: DropDelegate {
  let item: PickedColor
  @Binding var listData: [PickedColor]
  @Binding var current: PickedColor?
  
  func dropEntered(info: DropInfo) {
    if item != current {
      let from = listData.firstIndex(of: current!)!
      let to = listData.firstIndex(of: item)!
      if listData[to].id != current!.id {
        listData.move(
          fromOffsets: IndexSet(integer: from),
          toOffset: to > from ? to + 1 : to
        )
      }
    }
  }
  
  func dropUpdated(info: DropInfo) -> DropProposal? {
    return DropProposal(operation: .move)
  }
  
  func performDrop(info: DropInfo) -> Bool {
    self.current = nil
    return true
  }
}

struct DropOutsideDelegate: DropDelegate {
  @Binding var current: PickedColor?
  
  func performDrop(info: DropInfo) -> Bool {
    current = nil
    return true
  }
}
