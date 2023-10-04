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

    @Query var destinations: [Destination]
    @State private var path = [Destination]()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            NavigationStack(path: $path) {
                List {
                    ForEach(destinations) { destination in
                        NavigationLink(value: destination)  {
                            VStack(alignment: .leading) {
                                Text(destination.name)
                                    .font(.headline)

                                Text(destination.date.formatted(date: .long, time: .shortened))
                            }
                        }
                    }
                    .onDelete(perform: deleteDestinations)
                }
                .navigationTitle("iTour")
                .navigationDestination(for: Destination.self, destination: EditDestinationView.init)
                .toolbar {
                    Button("Add Samples", action: addSamples)
                    Button("Add Destination", systemImage: "plus", action: addDestination)
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

    func deleteDestinations(_ indexSet: IndexSet) {
        for index in indexSet {
            let destination = destinations[index]
            modelContext.delete(destination)
        }
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
