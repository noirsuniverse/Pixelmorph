//
//  Item.swift
//  PixelMorph
//
//  Created by Mohamed Abdullahi on 11/08/2024.
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
