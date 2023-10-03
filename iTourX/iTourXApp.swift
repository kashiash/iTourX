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
            ContentView()
        }
        .modelContainer(for: Destination.self)
    }
}
