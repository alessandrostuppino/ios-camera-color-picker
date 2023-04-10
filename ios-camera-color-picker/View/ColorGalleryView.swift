//
//  Camera Colour Picker
//

import SwiftUI

struct ColorGalleryView: View {
  @Binding var gallery: [PickedColor]
  
  @State private var dragging: PickedColor?
  @State private var sorting: Sorting = .date
  @State private var showDeleteAllAlert = false
  
  @Environment(\.dismiss) private var dismiss
  private let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  var body: some View {
    NavigationView {
      ScrollView {
        if gallery.isEmpty {
          emptyCollection
        } else {
          collection
        }
      }
      .onDrop(of: [.text], delegate: DropOutsideDelegate(current: $dragging))
      .toolbar {
        closeButton
        sortButton
        deleteAllButton
      }
      .onChange(of: sorting, perform: sort)
    }
    .alert(
      Strings.ColorGalleryView.alertTitle.localized,
      isPresented: $showDeleteAllAlert
    ) {
      Button(Strings.ColorGalleryView.alertNo.localized, role: .cancel) {}
      Button(Strings.ColorGalleryView.alertYes.localized, role: .destructive) {
        gallery = []
        UserDefaults.standard.set(nil, forKey: Constants.kPickedColors)
      }
    } message: {
      Text(Strings.ColorGalleryView.alertMessage.localized)
    }
  }
  
  /// Creates a grid item for a given color.
  /// - Parameter p: The picked color used to create the item
  /// - Returns: The view containing the color and the text of its hexadecimal.
  @ViewBuilder private func item(with p: PickedColor) -> some View {
    let color = p.color
    
    ZStack {
      color
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(8)
      
      if let hex = color.hex, let isLight = color.isLight {
        Text(hex)
          .font(.title2)
          .bold()
          .italic()
          .foregroundColor(isLight ? .black : .white)
      }
    }
    .contextMenu {
      Button {
        UIPasteboard.general.string = color.hex
      } label: {
        HStack{
          Constants.Images.copy
          Text(localizable: Strings.ColorGalleryView.copyHex)
        }
      }
      
      Button {
          gallery.removeAll(where: { $0.id == p.id })
      } label: {
        HStack {
          Constants.Images.delete
          Text(localizable: Strings.ColorGalleryView.deleteColor)
        }
      }
    }
  }
  
  /// The collection of colors saved in the gallery.
  private var collection: some View {
    LazyVGrid(columns: columns) {
      ForEach(gallery.reversed()) { color in
        item(with: color)
          .onDrag {
            self.dragging = color
            
            return NSItemProvider(object: color.id.uuidString as NSString)
          }
          .onDrop(of: [.text], delegate: DragRelocateDelegate(item: color, listData: $gallery, current: $dragging))
      }
    }
    .animation(.default, value: gallery)
    .padding()
  }
  
  /// The text shown in case the color gallery is empty.
  private var emptyCollection: some View {
    Text(localizable: Strings.ColorGalleryView.noColorsSaved)
      .font(.title2)
      .foregroundColor(Color(uiColor: .lightGray))
      .padding(.vertical)
  }
  
  /// The button placed in the toolbar in the leading placement used to dismiss the sheet.
  private var closeButton: ToolbarItem<(), Button<some View>> {
    ToolbarItem(placement: .navigationBarLeading) {
      Button {
        dismiss()
      } label: {
        Constants.Images.close
          .resizable()
          .aspectRatio(1, contentMode: .fit)
          .bold()
      }
    }
  }
  
  /// The button placed in the toolbar in the trailing placement used to change the items sorting.
  private var sortButton: ToolbarItem<(), some View> {
    ToolbarItem(placement: .navigationBarTrailing) {
      Button {
        sorting.toggle()
      } label: {
        Constants.Images.filter
          .resizable()
          .aspectRatio(1, contentMode: .fit)
          .bold()
          .contextMenu {
            Button(Strings.ColorGalleryView.sortByDate.localized) {
              sorting = .date
            }
            
            Button(Strings.ColorGalleryView.sortFromBrighter.localized) {
              sorting = .brightness(true)
            }
            
            Button(Strings.ColorGalleryView.sortFromDarker.localized) {
              sorting = .brightness(false)
            }
          }
      }
      .disabled(gallery.count <= 1)
    }
  }
  
  /// The button placed in the toolbar in the trailing placement used to delete all the saved colors.
  private var deleteAllButton: ToolbarItem<(), some View> {
    ToolbarItem(placement: .navigationBarTrailing) {
      Button {
        showDeleteAllAlert.toggle()
        UserDefaults.standard.set(nil, forKey: Constants.kPickedColors)
      } label: {
        Constants.Images.delete
          .resizable()
          .aspectRatio(1, contentMode: .fit)
          .bold()
      }
      .disabled(gallery.isEmpty)
    }
  }
  
  /// Sorts the gallery list based on the selected sorting.
  private func sort(_ s: Sorting) {
    gallery.sort { p1, p2 in
      switch s {
      case .date:
        return p1.created <= p2.created
      case .brightness(let light):
        return light ? p1.color.brightness >= p2.color.brightness : p1.color.brightness <= p2.color.brightness
      }
    }
  }
}

fileprivate extension ColorGalleryView {
  /// The enum that determines the sorting of the gallery.
  enum Sorting: Equatable {
    /// Sorts the items of the gallery by creation date.
    case date
    
    /// Sorts the items of the gallery by its brightness. From brighter to darker in case of `true` and from darker to brighter in case of `false` parameter.
    case brightness(Bool)
    
    /// Toggles between the different kind of sortings available.
    mutating func toggle() {
      switch self {
      case .date:
        self = .brightness(true)
      case .brightness(let light):
        self = light ? .brightness(false) : .date
      }
    }
  }
}

struct ColorGalleryView_Previews: PreviewProvider {
  @State private static var gallery = [
    PickedColor(.red),
    PickedColor(.green),
    PickedColor(.blue),
    PickedColor(.yellow)
  ]
  
  static var previews: some View {
    ColorGalleryView(gallery: $gallery)
  }
}
