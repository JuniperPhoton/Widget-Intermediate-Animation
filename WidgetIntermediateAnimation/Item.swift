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
    var id: String
    var text: String
    var createdDate: Date?
    var completedDate: Date?
    
    init(id: String, text: String, createdDate: Date?, completedDate: Date?) {
        self.id = id
        self.text = text
        self.createdDate = createdDate
        self.completedDate = completedDate
    }
}
