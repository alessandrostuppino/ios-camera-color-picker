//
//  Camera Colour Picker
//

import SwiftUI

struct ContentView: View {
  /// The view model of the view containing values and logics.
  @StateObject private var viewModel = ContentViewModel()
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        frameView(with: geometry)
        
        if viewModel.canShowFinderView {
          FinderView(color: $viewModel.pickedColor.color)
          .frame(
            maxWidth: CGFloat(viewModel.frame?.width ?? 0),
            maxHeight: CGFloat(viewModel.frame?.height ?? 0),
            alignment: .center
          )
          .padding(.bottom)
        }
        
        ErrorView(error: viewModel.error)
      }
    }
    .sheet(isPresented: $viewModel.isGalleryPresented) {
      ColorGalleryView(gallery: $viewModel.pickedColors)
    }
  }
  
  /// Creates a frame with camera preview with the given geometry proxy.
  /// - Parameter geometry: The geometry proxy.
  /// - Returns: A view containing the prevew of the camera and all the controls.
  @ViewBuilder private func frameView(with geometry: GeometryProxy) -> some View {
    FrameView(image: viewModel.frame)
      .edgesIgnoringSafeArea(.all)
      .safeAreaInset(edge: .top) {
        Color.clear
          .frame(height: geometry.safeAreaInsets.top)
          .background(Material.bar)
          .edgesIgnoringSafeArea(.top)
      }
      .safeAreaInset(edge: .bottom) {
        ZStack {
          Color.clear
          
          HStack(spacing: 20) {
            pickedColorsList
            Spacer()
            flashButton
          }
          
          pickColorButton
        }
        .padding(.top)
        .padding(.horizontal, geometry.safeAreaInsets.bottom*1.5)
        .frame(height: geometry.safeAreaInsets.bottom*2)
        .background(Material.bar)
        .edgesIgnoringSafeArea(.bottom)
      }
  }
  
  /// The bottom left button representing the thumbnails of the last three picked colors. Used to navigate to the list of picked colors.
  private var pickedColorsList: some View {
    ColorGalleryThumbnail(colors: $viewModel.pickedColors)
      .onTapGesture {
        viewModel.isGalleryPresented.toggle()
      }
  }
  
  /// The button used to pick a color.
  private var pickColorButton: some View {
    Button {
      viewModel.addColor()
    } label: {
      Constants.Images.pickColor
        .resizable()
        .aspectRatio(1, contentMode: ContentMode.fit)
        .tint(.white)
    }
  }
  
  /// The button that toggles on and off the device torch.
  private var flashButton: some View {
    Button(action: viewModel.toggleFlash) {
      flashButtonIcon
        .resizable()
        .scaledToFit()
        .frame(maxHeight: 25)
        .tint(.white)
    }
    .disabled(viewModel.isFlashOn == nil)
  }
  
  /// The icon of the flash that changes based on its on/off status.
  private var flashButtonIcon: Image {
    let flash = viewModel.isFlashOn ?? false
    
    return flash ? Constants.Images.enabledFlash : Constants.Images.disabledFlash
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
