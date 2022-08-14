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
    
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"
    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects
        projects = FetchRequest<Project>(entity: Project.entity(),
                                         sortDescriptors: [
                                            NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)
                                         ],predicate: NSPredicate(format: "closed = %d", showClosedProjects))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(projects.wrappedValue) { project in
                    Section {
                        ForEach(project.projectItems(using: sortOrder)) { item in
                            ItemRowView(item: item)
                        }
                        .onDelete { offsets in
                            let allItems = project.projectItems
                            for offset in offsets {
                                let item = allItems[offset]
                                dataController.delete(item)
                            }
                            // this provides you to delete immiediately from core data
                            //   dataController.container.viewContext.processPendingChanges()
                            dataController.save()
                        }
                        if showClosedProjects == false {
                            Button {
                                withAnimation {
                                    let item = Item(context: managedObjectContext)
                                    item.project = project
                                    item.creationDate = Date()
                                    dataController.save()
                                }
                            } label: {
                                Label("Add New Item",systemImage: "plus")
                            }
                            
                        }
                    } header: {
                        ProjectHeaderView(project: project)
                    }
                }
            }.listStyle(.insetGrouped)
                .navigationTitle(showClosedProjects ? "Closed Projects" :  "Open Projects")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if showClosedProjects == false {
                            Button {
                                withAnimation {
                                    let project = Project(context: managedObjectContext)
                                    project.closed = false
                                    project.creationDate = Date()
                                    dataController.save()
                                }
                            } label: {
                                Label("Add Project",systemImage: "plus")
                            }
                            
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            showSortOrder.toggle()
                        } label: {
                            Label("Sort",systemImage: "arrow.up.arrow.down")
                        }
                        
                    }
                    
                }
                .confirmationDialog("Sort by...", isPresented: $showSortOrder) {
                    Button("Optimized") { sortOrder = .optimized  }
                    Button("Creation Date") { sortOrder =  .creationDate  }
                    Button("Title") { sortOrder = .title  }
                    Button("Cancel",role: .cancel) { }
                } message: {
                    Text("Sort by something")
                }
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
