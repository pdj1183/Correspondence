//
//  ContentView.swift
//  Correspondence
//
//  Created by Phillip Johnson on 7/2/25.
//

import SwiftUI
import SwiftData

enum SidebarItem: Hashable {
    case chats
    case agents
    case projects
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.openSettings) private var openSettings
    @Query(sort: \Conversation.updatedAt, order: .reverse) private var conversations: [Conversation]

    // Sidebar selection
    @State private var selectedSidebar: SidebarItem? = .chats

    // Content (middle column) selection
    @State private var selectedConversation: Conversation?
    @State private var selectedAgent: Agent?
    @State private var selectedProject: Project?
    @State private var searchText: String = ""

    private var filteredConversations: [Conversation] {
        guard !searchText.isEmpty else { return conversations }
        return conversations.filter { convo in
            // Match on title
            if convo.title.localizedCaseInsensitiveContains(searchText) {
                return true
            }

            // Find latest message content
            let messages: [Message] = convo.messages
            var latestMessage: Message?
            for msg in messages {
                if let current = latestMessage {
                    if current.createdAt < msg.createdAt {
                        latestMessage = msg
                    }
                } else {
                    latestMessage = msg
                }
            }
            let latestContent: String = latestMessage?.content ?? ""
            return latestContent.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationSplitView {
            SidebarView(selectedSidebar: $selectedSidebar)
        } content: {
            ContentColumnView(
                selectedSidebar: $selectedSidebar,
                selectedConversation: $selectedConversation,
                selectedAgent: $selectedAgent,
                selectedProject: $selectedProject,
                searchText: $searchText,
                conversations: conversations,
                filteredConversations: filteredConversations,
                addConversation: addConversation
            )
        } detail: {
            DetailView(
                selectedSidebar: $selectedSidebar,
                selectedConversation: $selectedConversation, // <- updated
                conversations: conversations
            )
        }
    }

    private func addConversation() {
        @AppStorage("defaultModel") var defaultModel: String = "gpt-4"
        let convo = Conversation(title: "New Chat", model: defaultModel)
        modelContext.insert(convo)
        // Ensure we're in the Chats section and select the new convo
        selectedSidebar = .chats
        selectedConversation = convo   // <- updated
    }
}

#Preview("ContentView - Empty") {
    let container = try! ModelContainer(
        for: Conversation.self,
            Message.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    return ContentView()
        .modelContainer(container)
}

#Preview("ContentView - With Sample Data") {
    let container = try! ModelContainer(
        for: Conversation.self,
            Message.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let context = container.mainContext

    let convo1 = Conversation(title: "Project Ideas")
    let convo2 = Conversation(title: "Grocery List")

    let msg1 = Message(role: "user", content: "Brainstorm some app ideas.", conversation: convo1)
    let msg2 = Message(role: "assistant", content: "How about a habit tracker?", conversation: convo1)
    convo1.messages.append(contentsOf: [msg1, msg2])
    convo1.updatedAt = Date()

    let msg3 = Message(role: "user", content: "Milk, eggs, bread", conversation: convo2)
    convo2.messages.append(msg3)
    convo2.updatedAt = Date().addingTimeInterval(-60)

    context.insert(convo1)
    context.insert(convo2)

    return ContentView()
        .modelContainer(container)
        .frame(width: 1000, height: 600)
        .environmentObject(GlobalModels())
}
