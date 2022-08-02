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
                        ForEach(project.items?.allObjects as? [Item] ?? []) { item in
                            Text(item.title ?? "")
                        }
                    } header: {
                        Text(project.title ?? "")
                    }
                }
            }.listStyle(.insetGrouped)
                .navigationTitle(showClosedProjects ? "Closed Projects" :  "Open Projects")
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
