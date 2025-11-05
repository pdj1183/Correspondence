//
//  DetailView.swift
//  Correspondence
//
//  Created by Phillip Johnson on 9/5/25.
//

import SwiftUI

struct DetailView: View {
    @Binding var selectedSidebar: SidebarItem?
    @Binding var selectedConversation: Conversation?
    @Binding var selectedAgent: Agent?
    @Binding var selectedProject: Project?
    var conversations: [Conversation]

    var body: some View {
        Group {
            switch selectedSidebar {
            case .chats:
                if let convo = selectedConversation {
                    ChatView(conversation: convo)
                } else {
                    Text("Select a conversation")
                        .foregroundColor(.secondary)
                }
            case .agents:
                if let agent = selectedAgent {
                    AgentDetailForm(agent: agent)
                } else {
                    Text("Select an agent ")
                        .foregroundColor(.secondary)
                }

            case .projects:
                Text("Project detail view")

            case .none:
                Text("Select a section")
                    .foregroundColor(.secondary)
            }
        }
    }
}
