//
//  Camera Colour Picker
//

import Foundation

enum CameraError: Error {
  case cameraUnavailable
  case cannotAddInput
  case cannotAddOutput
  case createCaptureInput(Error)
  case deniedAuthorization
  case restrictedAuthorization
  case unknownAuthorization
}

extension CameraError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .cameraUnavailable:
      return Strings.CameraError.unavailable.localized
    case .cannotAddInput:
      return Strings.CameraError.noCaptureInput.localized
    case .cannotAddOutput:
      return Strings.CameraError.noVideoOutput.localized
    case .createCaptureInput(let error):
      return Strings.CameraError.creatingCaptureInput.localized + error.localizedDescription
    case .deniedAuthorization:
      return Strings.CameraError.accessDenied.localized
    case .restrictedAuthorization:
      return Strings.CameraError.restrictedCaptureDevice.localized
    case .unknownAuthorization:
      return Strings.CameraError.unknownAuthorization.localized
    }
  }
}
