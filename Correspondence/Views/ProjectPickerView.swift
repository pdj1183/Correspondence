//
//  ProjectPickerView.swift
//  Correspondence
//
//  Created as part of refactoring ContentColumnView.
//

import SwiftUI
import SwiftData

struct ProjectPickerView: View {
    @Bindable var conversation: Conversation
    @Query(sort: \Project.name, order: .forward) private var projects: [Project]

    var body: some View {
        VStack {
            Text("Select Project").font(.headline)
            Picker("Project", selection: $conversation.project) {
                ForEach(projects, id: \.id) { project in
                    Text(project.name).tag(project as Project?)
                }
                Text("None")
                    .tag(nil as String?)
            }
            HStack{
                Button {
                    // Action for creating a new project
                } label: {
                    Label("Create New Project", systemImage: "plus")
                }
            }
        }
        .padding()
        .frame(width: 300)
    }
}
