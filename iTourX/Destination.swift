//
//  Destination.swift
//  iTourX
//
//  Created by Jacek Kosinski U on 03/10/2023.
//

import Foundation
import SwiftData

@Model
class Destination {
    var name: String
    var details: String
    var date: Date
    var priority: Int
    @Attribute(.externalStorage)
    var image: Data?

    //@Relationship(deleteRule: .cascade)
    @Relationship(deleteRule: .cascade, inverse: \Sight.destination)
    var sights = [Sight]()

    init(name: String = "", details: String = "", date: Date = Date(), priority: Int = 2) {
        self.name = name
        self.details = details
        self.date = date
        self.priority = priority
    }
}
