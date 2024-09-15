//
//  Item.swift
//  Hack24
//
//  Created by Edgar Patricio Olalde Sepulveda on 14/09/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
