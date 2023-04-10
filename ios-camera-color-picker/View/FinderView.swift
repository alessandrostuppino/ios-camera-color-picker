//
//  Camera Colour Picker
//

import SwiftUI

struct FinderView: View {
  @Binding var color: Color
  @State private var finderColor: Color = Color(uiColor: .darkGray)
  
  var body: some View {
    ZStack {
      Group {
        Rectangle()
          .fill(finderColor)
          .frame(width: 40, height: 1, alignment: .center)
        
        Rectangle()
          .fill(finderColor)
          .frame(width: 1, height: 40, alignment: .center)
      }
      .opacity(0.5)
      
      Circle()
        .strokeBorder(color, lineWidth: 4)
        .background(Circle().fill(.clear))
        .frame(width: 40, height: 40, alignment: .center)
        
      Group {
        Circle()
          .strokeBorder(finderColor, lineWidth: 1)
          .background(Circle().fill(.clear))
          .frame(width: 34, height: 34, alignment: .center)
        
        Circle()
          .strokeBorder(finderColor, lineWidth: 1)
          .background(Circle().fill(.clear))
          .frame(width: 42, height: 42, alignment: .center)
      }
      .opacity(0.5)
    }
    .onChange(of: color) { newValue in
      if let light = newValue.isLight {
        finderColor = light ? Color.black : Color.white
      } else {
        finderColor = Color(uiColor: .darkGray)
      }
    }
  }
}

struct FinderView_Previews: PreviewProvider {
  static var previews: some View {
    FinderView(color: .constant(.red))
  }
}
