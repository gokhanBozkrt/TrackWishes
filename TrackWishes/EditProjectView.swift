//
//  EditProjectView.swift
//  TrackWishes
//
//  Created by Gokhan Bozkurt on 9.08.2022.
//

import SwiftUI

struct EditProjectView: View {
    let project: Project
    @EnvironmentObject var dataConroller: DataController
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String
    @State private var detail: String
    @State private var color: String
    @State private var showingDeleteConfirm = false
    let colorColums = [
        GridItem(.adaptive(minimum: 44))
    ]
    init(project: Project) {
        self.project = project
        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)
    }

    var body: some View {
        Form {
            Section {
                TextField("Project Name", text: $title.onChange(update))
                TextField("Description of this project", text: $detail.onChange(update))
            } header: {
                Text("Basic Settings")
            }
            
            Section {
                LazyVGrid(columns: colorColums) {
                    ForEach(Project.colors, id: \.self) { item in
                        ZStack {
                            Color(item)
                                .aspectRatio(1, contentMode: .fit)
                                .cornerRadius(6)
                            if item == color {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                            }
                        }
                        .onTapGesture {
                            color = item
                            update()
                        }
                    }
                }.padding(.vertical)
            } header: {
                Text("Custom Project Colors")
            }
            
            Section() {
                Button(project.closed ? "Reopen the project" : "Close the project") {
                    project.closed.toggle()
                    update()
                }
                Button("Delete this project") {
                    showingDeleteConfirm.toggle()
             
                }
                .tint(.red)
            } footer: {
                Text("Closing a project moves it from the Open to Closed tab; deleting it removes the project completely.")
            }
        }.navigationTitle("Edit Project")
            .onDisappear(perform: dataConroller.save)
            .alert("Delete Project?", isPresented: $showingDeleteConfirm) {
                Button("Cancel", role: .cancel) {  }
                Button("Delete",role: .destructive) { delete() }
               
            } message: {
                Text("Are you sure you want to delete this project? You will also delete all the items it contains.")
            }
    }
    func update() {
        project.title = title
        project.detail = detail
        project.color = color
    }
    func delete() {
        dataConroller.delete(project)
        dismiss()
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
    }
}



/*
 
 */
