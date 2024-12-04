//
//  Item.swift
//  FitMe
//
//  Created by Andrei Roberto Oleniuc on 30.11.2024.
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
