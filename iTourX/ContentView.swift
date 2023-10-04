//
//  ContentView.swift
//  iTourX
//
//  Created by Jacek Kosinski U on 03/10/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext

    @State private var sortOrder = SortDescriptor(\Destination.name)
    @State private var path = [Destination]()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            NavigationStack(path: $path) {
                DestinationListingView(sort: sortOrder)
                    .navigationTitle("iTour")
                    .navigationDestination(for: Destination.self, destination: EditDestinationView.init)
                    .toolbar {
                        Button("Add Samples", action: addSamples)
                        Button("Add Destination", systemImage: "plus", action: addDestination)
                        Menu("Sort", systemImage: "arrow.up.arrow.down") {
                            Picker("Sort", selection: $sortOrder) {
                                Text("Name")
                                    .tag(SortDescriptor(\Destination.name))

                                Text("Priority")
                                    .tag(SortDescriptor(\Destination.priority, order: .reverse))

                                Text("Date")
                                    .tag(SortDescriptor(\Destination.date))
                            }
                            .pickerStyle(.inline)
                        }
                    }
            }
        }
        .padding()
    }
    func addSamples() {
        let rome = Destination(name: "Rome")
        let florence = Destination(name: "Florence")
        let naples = Destination(name: "Naples")

        modelContext.insert(rome)
        modelContext.insert(florence)
        modelContext.insert(naples)
    }


    func addDestination() {
        let destination = Destination()
        modelContext.insert(destination)
        path = [destination]
    }
}

#Preview {
    ContentView()
}
