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
                Text("Agent detail view")

            case .projects:
                Text("Project detail view")

            case .none:
                Text("Select a section")
                    .foregroundColor(.secondary)
            }
        }
    }
}
