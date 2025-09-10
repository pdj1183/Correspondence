//
//  ContentColumnView.swift
//  Correspondence
//
//  Created by Phillip Johnson on 9/5/25.
//

import SwiftUI
import SwiftData

struct ContentColumnView: View {
    @Binding var selectedSidebar: SidebarItem?
    @Binding var selectedConversationID: UUID?
    @Binding var searchText: String
    var conversations: [Conversation]
    var filteredConversations: [Conversation]
    var addConversation: () -> Void

    var body: some View {
        Group {
            switch selectedSidebar {
            case .chats:
                List(filteredConversations, selection: $selectedConversationID) { convo in
                    VStack(alignment: .leading) {
                        Text(convo.title).font(.headline)
                        if let last = (convo.messages as [Message]).max(by: { (a: Message, b: Message) -> Bool in
                            a.createdAt < b.createdAt
                        }) {
                            Text(last.content)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }
                    .tag(convo.id)
                }
                .navigationTitle("Chats")
                .searchable(text: $searchText) {
                    ForEach(
                        conversations
                            .filter { convo in
                                !searchText.isEmpty &&
                                convo.title.localizedCaseInsensitiveContains(searchText)
                            }
                            .prefix(5),
                        id: \.id
                    ) { convo in
                        Text(convo.title).searchCompletion(convo.title)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: addConversation) {
                            Label("New Chat", systemImage: "plus")
                        }
                    }
                }

            case .agents:
                Text("Agents section")
                    .navigationTitle("Agents")

            case .projects:
                Text("Projects section")
                    .navigationTitle("Projects")

            case .none:
                Text("Select a section")
                    .foregroundColor(.secondary)
            }
        }
    }
}
