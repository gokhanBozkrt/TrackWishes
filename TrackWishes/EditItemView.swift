//
//  EditItemView.swift
//  TrackWishes
//
//  Created by Gokhan Bozkurt on 5.08.2022.
//

import SwiftUI

struct EditItemView: View {
    let item: Item
    @EnvironmentObject var dataController: DataController
    @State private var title: String
    @State private var detail: String
    @State private var priority: Int
    @State private var completed: Bool
    
    init(item: Item) {
        self.item = item
        _title = State(wrappedValue: item.itemTitle)
        _detail = State(wrappedValue: item.itemDetail)
        _priority = State(wrappedValue: Int(item.priority))
        _completed = State(wrappedValue: item.completed)
    }
    var body: some View {
        Form {
            Section {
                TextField("Item Name", text: $title)
                TextField("Description", text: $detail)
            } header: {
                Text("Basic Settings")
            }
            Section {
                Picker("Priority",selection: $priority) {
                    Text("Low").tag(1)
                    Text("Medium").tag(2)
                    Text("High").tag(3)
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Priority")
            }
            Section {
              Toggle("Mark Completed",isOn: $completed)
            }
        }.navigationTitle("Edit Form")
            .onDisappear(perform: update)
    }
    func update() {
        item.project?.objectWillChange.send()
        item.title = title
        item.detail = detail
        item.priority = Int16(priority)
        item.completed = completed
    }
}

struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(item: Item.example)
    }
}
