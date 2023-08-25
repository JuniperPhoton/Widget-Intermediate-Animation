//
//  ContentView.swift
//  WidgetIntermediateAnimation
//
//  Created by Photon Juniper on 2023/8/23.
//

import SwiftUI
import SwiftData
import WidgetKit

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: [SortDescriptor(\Item.createdDate, order: .reverse)],
           animation: .default)
    private var items: [Item]
    
    @State private var inputText = ""
    
    var body: some View {
        NavigationSplitView {
            VStack {
                HStack {
                    TextField("Input text to add", text: $inputText)
                        .onSubmit {
                            addItem()
                        }
                    
                    Button(action: addItem) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                }.padding()
                
                List {
                    ForEach(items) { item in
                        HStack {
                            Button {
                                toggleComplete(item: item)
                            } label: {
                                Image(systemName: item.completedDate != nil ? "checkmark.circle.fill" : "circle")
                            }.foregroundStyle(Color.accentColor)
                            
                            Text(item.text)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }.frame(maxHeight: .infinity, alignment: .top)
            }.toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        deleteAll()
                    } label: {
                        Text("Delete all")
                    }
                }
#endif
            }
        } detail: {
            Text("Select an item")
        }.onChange(of: items) { _,_ in
            WidgetCenter.shared.reloadAllTimelines()
        }.onChange(of: scenePhase) { oldValue, newValue in
            if newValue == .background {
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
    
    private func toggleComplete(item: Item) {
        withAnimation {
            if item.completedDate == nil {
                item.completedDate = .now
            } else {
                item.completedDate = nil
            }
        }
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func deleteAll() {
        withAnimation {
            try? modelContext.delete(model: Item.self)
        }
    }
    
    private func addItem() {
        if inputText.isEmpty {
            return
        }
        
        withAnimation {
            let newItem = Item(id: UUID().uuidString, text: inputText, createdDate: .now, completedDate: nil)
            modelContext.insert(newItem)
            inputText = ""
        }
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
        
        WidgetCenter.shared.reloadAllTimelines()
    }
}
