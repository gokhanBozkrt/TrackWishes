//
//  ProjectHeaderView.swift
//  TrackWishes
//
//  Created by Gokhan Bozkurt on 7.08.2022.
//

import SwiftUI

struct ProjectHeaderView: View {
    @ObservedObject var project: Project
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(project.projectTitle)
                ProgressView(value: project.completionAmount)
                    .tint(Color(project.projectColor))
            }
            Spacer()
            NavigationLink {
                EmptyView()
            } label: {
                Image(systemName: "square.and.pencil")
                    .imageScale(.large)
            }

        }
        .padding(.bottom,10)
    }
}

struct ProjectHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectHeaderView(project: Project.example)
    }
}
