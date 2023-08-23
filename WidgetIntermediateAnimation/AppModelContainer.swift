//
//  AppModelContainer.swift
//  WidgetIntermediateAnimation
//
//  Created by chaos on 2023/8/24.
//

import Foundation
import SwiftData

var sharedModelContainer: ModelContainer = {
    let schema = Schema([
        Item.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()
