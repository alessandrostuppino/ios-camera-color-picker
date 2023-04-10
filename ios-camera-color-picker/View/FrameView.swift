//
//  Camera Colour Picker
//

import SwiftUI

struct FrameView: View {
  var image: CGImage?
  private let label = Text(localizable: Strings.FrameView.cameraFeed)
  
  var body: some View {
    if let image {
      GeometryReader { geometry in
        Image(image, scale: 1.0, orientation: .upMirrored, label: label)
          .resizable()
          .scaledToFill()
          .frame(
            width: geometry.size.width,
            height: geometry.size.height,
            alignment: .center
          )
          .clipped()
      }
    } else {
      Color.black
        .overlay {
          Text(localizable: Strings.FrameView.noCameraFeedAvailable)
            .foregroundColor(.white)
        }
        .ignoresSafeArea()
    }
  }
}

struct FrameView_Previews: PreviewProvider {
  static var previews: some View {
    FrameView()
  }
}
