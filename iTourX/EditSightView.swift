//
//  EditSightView.swift
//  iTourX
//
//  Created by Jacek Kosinski U on 07/11/2023.
//

import SwiftUI
import PhotosUI

struct EditSightView: View {
    @Bindable var sight: Sight

    @Environment(\.modelContext) private var modelContext
    @State private var photosItem : PhotosPickerItem?
    var body: some View {
        Form {
           TextField("Name", text: $sight.name)
//           TextField("Details", text: $sight.details, axis: .vertical)
            Section
            {
                if let imagedata = sight.image
                {
                    if let image = UIImage(data: imagedata) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    }
                }
                PhotosPicker("Attach photo", selection: $photosItem, matching: .images)
            }
            Text("Dupa")
        }
        .onChange(of: photosItem) {
            Task {
                sight.image = try? await photosItem?.loadTransferable(type: Data.self)
            }
        }
    }
}

//#Preview {
//    EditSightView()
//}
