//
//  ProjectsView.swift
//  TrackWishes
//
//  Created by Gokhan Bozkurt on 2.08.2022.
//

import SwiftUI

struct ProjectsView: View {
    static let openTag: String? = "Open Projects"
    static let closedTag: String? = "Closed Projects"

    @State private var showSortOrder = false
    @StateObject var viewModel: ViewModel
    var body: some View {
        NavigationView {
            Group {
                if viewModel.projects.isEmpty {
                    Text("There is nothing here right now")
                        .foregroundColor(.secondary)
                } else {
                    projectsLists
                }
            }
            .navigationTitle(viewModel.showClosedProjects ? "Closed Projects" :  "Open Projects")
                .toolbar {
                addProjectToolbar
                sortOptionsToolbar
                    
                }
                .confirmationDialog("Sort", isPresented: $showSortOrder) {
                    Button("Optimized") { viewModel.sortOrder = .optimized  }
                    Button("Creation Date") { viewModel.sortOrder =  .creationDate  }
                    Button("Title") { viewModel.sortOrder = .title  }
                    Button("Cancel",role: .cancel) { }
                } message: {
                    Text("Sort items")
                }
            SelectSomethingView()
        }
    }
    init(dataController: DataController,showClosedProjects: Bool) {
        let viewModel = ViewModel(dataController: dataController, showClosedProjects: showClosedProjects)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
 }

struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView(dataController: DataController.preview, showClosedProjects: false)
            
    }
}


extension ProjectsView {
    var projectsLists: some View {
        List {
            ForEach(viewModel.projects) { project in
                Section {
                    ForEach(project.projectItems(using: viewModel.sortOrder)) { item in
                        ItemRowView(project: project, item: item)
                    }
                    .onDelete { offsets in
                        viewModel.delete(offsets, from: project)
                        // this provides you to delete immiediately from core data
                        //   dataController.container.viewContext.processPendingChanges()
                        
                    }
                    if viewModel.showClosedProjects == false {
                        Button {
                            withAnimation {
                                viewModel.addItem(to: project)
                            }
                        } label: {
                            Label("Add New Item",systemImage: "plus")
                        }
                        
                    }
                } header: {
                    ProjectHeaderView(project: project)
                }
            }
        }
        .listStyle(.insetGrouped)
    }
    var addProjectToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if viewModel.showClosedProjects == false {
                    Button {
                        viewModel.addProject()
                        
                    } label: {
                        Label("Add New Project",systemImage: "plus")
                    }
            }
        }
    }
    var sortOptionsToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                showSortOrder.toggle()
            } label: {
                Label("Sort",systemImage: "arrow.up.arrow.down")
            }
            
        }
    }
}
