//
//  AgentPickerView.swift
//  Correspondence
//
//  Created as part of refactoring ContentColumnView.
//

import SwiftUI
import SwiftData

struct AgentPickerView: View {
    @Bindable var conversation: Conversation
    var addAgent: () -> Void
    @Query(sort: \Agent.name, order: .forward) private var agents: [Agent]

    var body: some View {
        VStack {
            Text("Select Agent").font(.headline)
            Picker("Agent", selection: $conversation.agent) {
                ForEach(agents, id: \.id) { agent in
                    Text(agent.name).tag(agent as Agent?)
                }
                Text("None")
                    .tag(nil as Agent?)
            }
            .onChange(of: conversation.agent) { _, newAgent in
                conversation.model = newAgent?.model
            }
            HStack{
                Button {
                    addAgent()
                } label: {
                    Label("Create New Agent", systemImage: "plus")
                }
            }
        }
        .padding()
        .frame(width: 300)
    }
}
