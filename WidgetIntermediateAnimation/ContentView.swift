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
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var inputText = ""
    
    var body: some View {
        NavigationSplitView {
            VStack {
                TextField("Input text to add", text: $inputText)
                    .padding()
                
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
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }.onChange(of: items) { _,_ in
            WidgetCenter.shared.reloadAllTimelines()
        }.onAppear {
            WidgetCenter.shared.reloadAllTimelines()
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
    
    private func addItem() {
        if inputText.isEmpty {
            return
        }
        
        withAnimation {
            let newItem = Item(id: UUID().uuidString, text: inputText, completedDate: nil)
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
