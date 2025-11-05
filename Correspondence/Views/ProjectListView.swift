import SwiftUI
import SwiftData

struct ProjectListView: View {
    @Binding var selectedProject: Project?
    var projects: [Project]
    
    var body: some View {
        List(projects, id: \.id, selection: $selectedProject) { project in
            VStack(alignment: .leading) {
                Text(project.name)
                    .font(.headline)
                Text(project.createdAt.formatted(date: .numeric, time: .omitted))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
        .navigationTitle("Projects")
    }
}
