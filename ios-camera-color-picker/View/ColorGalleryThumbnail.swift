//
//  Camera Colour Picker
//

import SwiftUI

struct ColorGalleryThumbnail: View {
  @Binding var colors: [PickedColor]
  
  var body: some View {
    HStack(spacing: -15) {
      ForEach(colors.reversed().slice(0...2)) { color in
        thumbnail(for: color)
      }
      
      ZStack {
        Circle()
          .fill(.white)
          .frame(width: 30, height: 30)
        
        Constants.Images.more
          .resizable()
          .aspectRatio(contentMode: .fit)
          .foregroundColor(.black)
          .frame(width: 15, height: 15, alignment: .center)
        
      }
    }
  }
  
  @ViewBuilder private func thumbnail(for p: PickedColor) -> some View {
    Circle()
      .strokeBorder(.white, lineWidth: 1.5)
      .background(Circle().fill(p.color))
      .frame(width: 30, height: 30)
      .cornerRadius(10)
  }
}

struct ColorGalleryThumbnail_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Color.black
      ColorGalleryThumbnail(colors: .constant([]))
    }
    .ignoresSafeArea()
  }
}
