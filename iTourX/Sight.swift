//
//  Sight.swift
//  iTourX
//
//  Created by Jacek Kosinski U on 04/10/2023.
//

import Foundation
import SwiftData

@Model
class Sight {
    var name: String
    var destination: Destination?


    init(name: String) {
        self.name = name
    }
}
