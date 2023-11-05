//
//  iTourXApp.swift
//  iTourX
//
//  Created by Jacek Kosinski U on 03/10/2023.
//

import SwiftUI
import SwiftData

@main
struct iTourXApp: App {
    var body: some Scene {
        WindowGroup {
            TabView
            {
                ContentView()
                    .tabItem { Label("Destiantions",systemImage: "map")}
                SightsView()
                    .tabItem { Label("Sights",systemImage: "mappin.and.ellipse") }
            }
        }
        .modelContainer(for: [Destination.self,Sight.self, ])
    }
}
