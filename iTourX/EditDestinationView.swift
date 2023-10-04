//
//  EditDestinationView.swift
//  iTourX
//
//  Created by Jacek Kosinski U on 04/10/2023.
//

import SwiftUI
import SwiftData

struct EditDestinationView: View {
    @Bindable var destination: Destination
    @State private var newSightName = ""
    var body: some View {
        Form {
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
                ForEach(destination.sights) { sight in
                    Text(sight.name)
                }

                HStack {
                    TextField("Add a new sight in \(destination.name)", text: $newSightName)

                    Button("Add", action: addSight)
                }
            }
        }
        .navigationTitle("Edit Destination")
        .navigationBarTitleDisplayMode(.inline)
    }
    func addSight() {
        guard newSightName.isEmpty == false else { return }

        withAnimation {
            let sight = Sight(name: newSightName)
            destination.sights.append(sight)
            newSightName = ""
        }
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
