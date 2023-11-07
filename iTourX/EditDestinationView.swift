//
//  EditDestinationView.swift
//  iTourX
//
//  Created by Jacek Kosinski U on 04/10/2023.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditDestinationView: View {

    @Bindable var destination: Destination
    @State private var newSightName = ""
    @Environment(\.modelContext) private var modelContext

    @State private var photosItem : PhotosPickerItem?

    var sortedSights: [Sight] {
        destination.sights.sorted {
            $0.name < $1.name
        }
    }

    var body: some View {
        Form {
            Section
            {
                if let imagedata = destination.image
                {
                    if let image = UIImage(data: imagedata) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    }
                }
                PhotosPicker("Attach photo", selection: $photosItem, matching: .images)
            }
            TextField("Name", text: $destination.name)
            TextField("Details", text: $destination.details, axis: .vertical)
            DatePicker("Date", selection: $destination.date)

            Section("Priority") {
                Picker("Priority", selection: $destination.priority) {
                    Text("Meh").tag(1)
                    Text("Maybe").tag(2)
                    Text("Must").tag(3)
                }
                .pickerStyle(.segmented)
            }
            Section("Sights") {
                NavigationStack
                {
                    List{
                        ForEach(sortedSights) { sight in
//                            NavigationLink{
//                                EditSightView(sight: sight)
//                            } label: {
                                Text(sight.name)
                           // }
                        }
                        .onDelete(perform: deleteSights)
                    }
                }

                HStack {
                    TextField("Add a new sight in \(destination.name)", text: $newSightName)

                    Button("Add", action: addSight)
                }
            }
        }
        .navigationTitle("Edit Destination")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: photosItem) {
            Task {
                destination.image = try? await photosItem?.loadTransferable(type: Data.self)
            }
        }
    }
    func addSight() {
        guard newSightName.isEmpty == false else { return }

        withAnimation {
            let sight = Sight(name: newSightName)
            destination.sights.append(sight)
            newSightName = ""
        }
    }
    func deleteSights(_ indexSet: IndexSet) {
        for index in indexSet {
            let sight = sortedSights[index]
            modelContext.delete(sight)
        }
        // not necessary when exist inverted relation to Destination
        //destination.sights.remove(atOffsets: indexSet)

    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Destination.self, configurations: config)

        let example = Destination(name: "Przykładowe miejsce docelowe", details: "Przykładowe szczegóły znajdują się tutaj i będą automatycznie rozszerzać się wertykalnie podczas ich edycji.")
        return EditDestinationView(destination: example)
            .modelContainer(container)
    } catch {
        fatalError("Nie udało się utworzyć kontenera modelu.")
    }
}
