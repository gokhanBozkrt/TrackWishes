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
                        ForEach(project.projectItems) { item in
                      ItemRowView(item: item)
                        }
                    } header: {
                       ProjectHeaderView(project: project)
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
