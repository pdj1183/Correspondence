import SwiftUI
import SwiftData

struct AgentListView: View {
    @Binding var selectedAgent: Agent?
    var agents: [Agent]
    var addAgent: () -> Void
    
    var body: some View {
        List(agents, id: \.id, selection: $selectedAgent) { agent in
            VStack(alignment: .leading) {
                Text(agent.name)
                    .font(.headline)
                Text((agent.updatedAt ?? agent.createdAt).formatted(date: .numeric, time: .omitted))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: addAgent) {
                    Label("New Agent", systemImage: "plus")
                }
            }
        }
        .navigationTitle("Agents")
    }
}
