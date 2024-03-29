//
//  WidgetShared.swift
//  WidgetIntermediateAnimation
//
//  Created by chaos on 2023/8/24.
//

import SwiftUI
import WidgetKit
import AppIntents
import SwiftData

/// Used in Widget only.
/// If we try to use the ``Item`` with ``@Model`` macro attached,
/// the Xcode preview won't work as expected.
struct SimpleItem {
    var id: String
    var text: String
    var completedDate: Date?
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct ReminderIntent: AppIntent {
    static var title: LocalizedStringResource = "Reminder intent"
    
    @Parameter(title: "Reminder id")
    var modelId: String
    
    init(modelId: String) {
        self.modelId = modelId
    }
    
    init() {
        // empty
    }
    
    func perform() async throws -> some IntentResult {
        let predicate = #Predicate<Item> { item in
            item.id == modelId
        }
        if let item = try? await sharedModelContainer.mainContext.fetch(.init(predicate: predicate)).first {
            item.completedDate = .now
        }
        return .result()
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), items: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), items: [])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        Task { @MainActor in
            var entries: [SimpleEntry] = []
            
            let now = Date.now
            
            let context = sharedModelContainer.mainContext
            let items = (try? context.fetch(FetchDescriptor<Item>())) ?? []
            let simpleItems = items.map { SimpleItem(id: $0.id, text: $0.text, completedDate: $0.completedDate) }
            
            let recentlyCompletedOrIncompleted = simpleItems.filter { item in
                if let completedDate = item.completedDate {
                    return abs(completedDate.timeIntervalSince(now)) < 2
                } else {
                    return true
                }
            }
            
            let incompleted = simpleItems.filter { $0.completedDate == nil }
            
            // First display items that are recently completed, which completedDate should within 2 seconds from now
            entries.append(SimpleEntry(date: now, items: recentlyCompletedOrIncompleted))
            
            // Then display incomplted items
            entries.append(SimpleEntry(date: now.addingTimeInterval(0.5), items: incompleted))
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let items: [SimpleItem]
}

struct AppWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        if entry.items.isEmpty {
            Text("No items")
        } else {
            VStack {
                ForEach(entry.items, id: \.id) { item in
                    HStack {
                        Button(intent: ReminderIntent(modelId: item.id)) {
                            if let completedDate = item.completedDate,
                               abs(completedDate.timeIntervalSince(.now)) < 2 {
                                Image(systemName: "checkmark.circle.fill")
                            } else {
                                Image(systemName: "circle")
                            }
                        }.buttonStyle(.plain).foregroundStyle(Color.accentColor)
                        
                        Text(item.text).lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }.transition(.push(from: .bottom))
                }
            }.frame(maxHeight: .infinity, alignment: .topLeading)
        }
    }
}
