//
//  DestinationListingView.swift
//  iTourX
//
//  Created by Jacek Kosinski U on 04/10/2023.
//

import SwiftUI
import SwiftData

struct DestinationListingView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Destination.priority, order: .reverse), SortDescriptor(\Destination.name)]) var destinations: [Destination]


    var body: some View {
        List {
            ForEach(destinations) { destination in
                NavigationLink(value: destination)  {
                    HStack {
                        if let photo = destination.image, let image = UIImage(data: photo) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .clipShape(.rect(cornerRadius: 5))
                                .frame(height: 100)
                        }
                        VStack(alignment: .leading) {
                            Text(destination.name)
                                .font(.headline)

                            Text(destination.date.formatted(date: .long, time: .shortened))
                        }
                    }
                }
            }
            .onDelete(perform: deleteDestinations)
        }
    }

    init(sort: [SortDescriptor<Destination>], searchString: String, minimumDate: Date) {
        _destinations = Query(filter: #Predicate {
            if searchString.isEmpty {
                return $0.date > minimumDate
            } else {
                return ($0.name.localizedStandardContains(searchString)
                        || $0.details.localizedStandardContains(searchString)
                        || $0.sights.contains
                        { $0.name.localizedStandardContains(searchString) })
                && $0.date > minimumDate
            }
        }, sort: sort)
    }

    func deleteDestinations(_ indexSet: IndexSet) {
        for index in indexSet {
            let destination = destinations[index]
            modelContext.delete(destination)
        }
    }
}


    #Preview {
        DestinationListingView(sort: [SortDescriptor(\Destination.name)], searchString: "",minimumDate: Date.distantPast)
    }

