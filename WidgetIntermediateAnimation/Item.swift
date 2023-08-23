//
//  Item.swift
//  WidgetIntermediateAnimation
//
//  Created by Photon Juniper on 2023/8/23.
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
