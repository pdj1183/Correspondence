//
//  ContentColumnView.swift
//  Correspondence
//
//  Created by Phillip Johnson on 9/5/25.
//

import SwiftUI
import SwiftData

struct ContentColumnView: View {
    @EnvironmentObject var GlobalModels: GlobalModels
    @Environment(\.modelContext) private var modelContext
    @Binding var selectedSidebar: SidebarItem?
    @Binding var selectedConversation: Conversation?
    @Binding var selectedAgent: Agent?
    @Binding var selectedProject: Project?
    @Binding var searchText: String
    var conversations: [Conversation]
    var agents: [Agent]
    var projects: [Project]
    var filteredConversations: [Conversation]
    var addConversation: () -> Void
    var addAgent: () -> Void

    
    @State private var showModelPopup = false
    @State private var showAgentPopup = false
    @State private var showProjectPopup = false
    
    
    var body: some View {
        Group {
            switch selectedSidebar {
            case .chats:
                ChatListView(
                    selectedConversation: $selectedConversation,
                    searchText: $searchText,
                    conversations: conversations,
                    filteredConversations: filteredConversations,
                    addConversation: addConversation,
                    addAgent: addAgent,
                    showModelPopup: $showModelPopup,
                    showAgentPopup: $showAgentPopup,
                    showProjectPopup: $showProjectPopup,
                    selectedConversationForPopups: selectedConversation,
                    deleteItems: deleteItems
                )
                
            case .agents:
                AgentListView(selectedAgent: $selectedAgent, agents: agents, addAgent: addAgent)
                
            case .projects:
                ProjectListView(selectedProject: $selectedProject, projects: projects)
                
            case .none:
                Text("Select a section")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let conversation = filteredConversations[index]
                modelContext.delete(conversation)
            }
            try? modelContext.save()
        }
    }
}

