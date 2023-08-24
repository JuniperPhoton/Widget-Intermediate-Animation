//
//  AppWidget.swift
//  AppWidget
//
//  Created by chaos on 2023/8/23.
//

import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

struct AppWidget: Widget {
    let kind: String = "AppWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                AppWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                AppWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: WidgetFamily.systemLarge) {
    AppWidget()
} timeline: {
    SimpleEntry(date: .now, items: [])
    SimpleEntry(date: .now, items: [
        .init(id: "0", text: "first", completedDate: nil)
    ])
    SimpleEntry(date: .now, items: [
        .init(id: "0", text: "first", completedDate: nil),
        .init(id: "1", text: "second", completedDate: nil)
    ])
    SimpleEntry(date: .now, items: [
        .init(id: "0", text: "first", completedDate: .now),
        .init(id: "1", text: "second", completedDate: nil)
    ])
    SimpleEntry(date: .now, items: [])
}
