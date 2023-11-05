//
//  SightsView.swift
//  iTourX
//
//  Created by Jacek Kosinski U on 05/11/2023.
//

import SwiftUI
import SwiftData

struct SightsView: View
{
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Sight.name) var sights: [Sight]

    var body: some View
    {
        NavigationStack
        {
            List{

                ForEach(sights)
                { sight in
                    NavigationLink(value: sight.destination)
                    {
                        Text(sight.name)
                    }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        let sight = sights[index]
                        modelContext.delete(sight)
                    }
                })
            }
            .navigationTitle("Sights")
            .navigationDestination(for: Destination.self, destination: EditDestinationView.init)

        }
    }
}

#Preview {
    SightsView()
}
