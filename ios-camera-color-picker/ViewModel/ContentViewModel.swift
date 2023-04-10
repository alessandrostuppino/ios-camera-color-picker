//
//  Camera Colour Picker
//

import CoreImage
import SwiftUI

/// The view model used to populate the content view.
class ContentViewModel: ObservableObject {
  
  // MARK: - Stored Properties
  
  /// The error coming from the camera manager.
  @Published var error: Error?
  
  /// The image representing the output of the capture session.
  @Published var frame: CGImage?
  
  /// Determines whether the torch is on or off.
  @Published var isFlashOn: Bool?
  
  /// The current color of the pixel in the middle of the frame.
  @Published var pickedColor: PickedColor
  
  /// The list of saved colors.
  @Published var pickedColors: [PickedColor]
  
  /// Determines whether the gallery view is currently presented or not.
  @Published var isGalleryPresented = false
  
  // MARK: - Computed Properties
  
  /// Determines whether the finder view should be shown or not.
  var canShowFinderView: Bool {
    frame != nil && pickedColor != PickedColor(.clear) && error == nil
  }
  
  // MARK: - Private Properties
  
  private let context = CIContext()
  private let cameraManager = CameraManager.shared
  private let frameManager = FrameManager.shared
  
  // MARK: - Init
  
  /// Creates a view model used in the content view.
  init() {
    isFlashOn = false
    pickedColor = PickedColor(.clear)
    pickedColors = UserDefaults
      .standard
      .string(forKey: Constants.kPickedColors)?
      .split(separator: Constants.pickedColorsSeparator)
      .compactMap {
        guard let color = Color(hex: String($0)) else { return nil }
        return PickedColor(color)
      } ?? []
    setupSubscriptions()
  }
  
  // MARK: - Helper Methods
  
  /// Populates the view model stored properties.
  func setupSubscriptions() {
    cameraManager.$error
      .receive(on: RunLoop.main)
      .map { $0 }
      .assign(to: &$error)
    
    frameManager.$current
      .receive(on: RunLoop.main)
      .compactMap { buffer in
        guard let image = CGImage.create(from: buffer) else {
          return nil
        }
        
        let ciImage = CIImage(cgImage: image)
        
        return self.context.createCGImage(ciImage, from: ciImage.extent)
      }
      .assign(to: &$frame)
    
    cameraManager.$isFlashOn
      .receive(on: RunLoop.main)
      .assign(to: &$isFlashOn)
    
    $frame
      .receive(on: RunLoop.main)
      .compactMap { image in
        guard let image, let uiColor = image.middlePixelColor else { return nil }
        
        return PickedColor(Color(uiColor: uiColor))
      }
      .assign(to: &$pickedColor)
  }
  
  /// Tells the camera to toggle the device torch.
  func toggleFlash() {
    cameraManager.toggleFlash()
  }
  
  func addColor() {
    guard pickedColor != PickedColor(.clear) else { return }
    
    pickedColors.append(pickedColor)
    UserDefaults.standard.set(
      pickedColors
        .compactMap { $0.color.hex }
        .joined(separator: Constants.pickedColorsSeparator),
      forKey: Constants.kPickedColors
    )
  }
}
