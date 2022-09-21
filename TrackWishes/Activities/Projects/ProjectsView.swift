//
//  ProjectsView.swift
//  TrackWishes
//
//  Created by Gokhan Bozkurt on 2.08.2022.
//

import SwiftUI

struct ProjectsView: View {
    let showClosedProjects: Bool
    let projects: FetchRequest<Project>
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var showSortOrder = false
    @State private var sortOrder = Item.SortOrder.optimized
    
    static let openTag: String? = "Open Projects"
    static let closedTag: String? = "Closed Projects"
    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects
        projects = FetchRequest<Project>(entity: Project.entity(),
                                         sortDescriptors: [
                                            NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)
                                         ],predicate: NSPredicate(format: "closed = %d", showClosedProjects))
    }
    
    var body: some View {
        NavigationView {
            Group {
                if projects.wrappedValue.isEmpty {
                    Text("There is nothing here right now")
                        .foregroundColor(.secondary)
                } else {
                    List {
                        ForEach(projects.wrappedValue) { project in
                            Section {
                                ForEach(project.projectItems(using: sortOrder)) { item in
                                    ItemRowView(project: project, item: item)
                                }
                                .onDelete { offsets in
                                    delete(offsets, from: project)
                                    // this provides you to delete immiediately from core data
                                    //   dataController.container.viewContext.processPendingChanges()
                                    
                                }
                                if showClosedProjects == false {
                                    Button {
                                        addItem(to: project)
                                        
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
            }
                .navigationTitle(showClosedProjects ? "Closed Projects" :  "Open Projects")
                .toolbar {
                addProjectToolbar
                sortOptionsToolbar
                    
                }
                .confirmationDialog("Sort", isPresented: $showSortOrder) {
                    Button("Optimized") { sortOrder = .optimized  }
                    Button("Creation Date") { sortOrder =  .creationDate  }
                    Button("Title") { sortOrder = .title  }
                    Button("Cancel",role: .cancel) { }
                } message: {
                    Text("Sort items")
                }
            SelectSomethingView()
        }
    }

    func addProject() {
        withAnimation {
            let project = Project(context: managedObjectContext)
            project.closed = false
            project.creationDate = Date()
            dataController.save()
        }
    }
    func delete(_ offsets: IndexSet, from project: Project) {
        let allItems = project.projectItems(using: sortOrder)
        for offset in offsets {
            let item = allItems[offset]
            dataController.delete(item)
        }
        dataController.save()
    }
    func addItem(to project: Project) {
        withAnimation {
            let item = Item(context: managedObjectContext)
            item.project = project
            item.creationDate = Date()
            dataController.save()
        }
    }
    
 }

struct ProjectsView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        ProjectsView(showClosedProjects: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}


extension ProjectsView {
  
    var addProjectToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if showClosedProjects == false {
                Button(action: addProject) {
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
