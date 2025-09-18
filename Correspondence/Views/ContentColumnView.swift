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
    @Binding var selectedSidebar: SidebarItem?
    @Binding var selectedConversation: Conversation?
    @Binding var selectedAgent: Agent?
    @Binding var selectedProject: Project?
    @Binding var searchText: String
    var conversations: [Conversation]
    var filteredConversations: [Conversation]
    var addConversation: () -> Void
    
    @State private var showModelPopup = false
    @State private var showAgentPopup = false
    @State private var showProjectPopup = false
    
    @Query(sort: \Agent.name, order: .forward) private var agents: [Agent]
    
    var body: some View {
        Group {
            switch selectedSidebar {
            case .chats:
                List(filteredConversations, selection: $selectedConversation) { convo in
                    VStack(alignment: .leading) {
                        // Editable title
                        TextField(
                            "Title",
                            text: Binding(
                                get: { convo.title },
                                set: { newValue in
                                    convo.title = newValue
                                    convo.updatedAt = Date()
                                }
                            )
                        )
                        .font(.headline)
                        .textFieldStyle(.plain)
                        .submitLabel(.done)
                        
                        Text(convo.updatedAt.formatted(date: .numeric, time: .omitted))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    .tag(convo)
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
                    
                    ToolbarItemGroup(placement: .secondaryAction) {
                        Button { showModelPopup = true } label: {
                            Label("Model", systemImage: "brain")
                        }
                        .popover(isPresented: $showModelPopup) {
                            if let conversation = selectedConversation {
                                ModelPickerView(conversation: conversation)
                            }
                        }
                        .disabled(selectedConversation == nil)
                        
                        Button { showAgentPopup = true } label: {
                            Label("Agent", systemImage: "person.bubble")
                        }
                        .popover(isPresented: $showAgentPopup) {
                            if let conversation = selectedConversation {
                                AgentPickerView(conversation: conversation)
                            }
                        }
                        .disabled(selectedConversation == nil)
                        
                        Button { showProjectPopup = true } label: {
                            Label("Project", systemImage: "folder")
                        }
                        .popover(isPresented: $showProjectPopup) {
                            if let conversation = selectedConversation {
                                ProjectPickerView(conversation: conversation)
                            }
                        }
                        .disabled(selectedConversation == nil)
                    }
                }
                
            case .agents:
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
    struct ModelPickerView: View {
        @EnvironmentObject var GlobalModels: GlobalModels
        @Bindable var conversation: Conversation


            var body: some View {
                VStack {
                    Text("Select Model").font(.headline)
                    Picker("Model", selection: $conversation.model) {
                        ForEach(GlobalModels.models, id: \.self) { model in
                            Text(model).tag(model as String?)
                        }
                    }
                }
                .padding()
                .frame(width: 300)
            }
        }

        struct AgentPickerView: View {
            @Bindable var conversation: Conversation
            @Query(sort: \Agent.name, order: .forward) private var agents: [Agent]

            var body: some View {
                VStack {
                    Text("Select Agent").font(.headline)
                    Picker("Agent", selection: $conversation.agent) {
                        ForEach(agents, id: \.id) { agent in
                            Text(agent.name).tag(agent.name as String?)
                        }
                    }
                    HStack{
                        Button("Create New Agent", systemImage: "plus") { }
                    }
                }
                .padding()
                .frame(width: 300)
            }
        }

        struct ProjectPickerView: View {
            @Bindable var conversation: Conversation
            @Query(sort: \Project.name, order: .forward) private var projects: [Project]

            var body: some View {
                VStack {
                    Text("Select Project").font(.headline)
                    Picker("Project", selection: $conversation.project) {
                        ForEach(projects, id: \.id) { project in
                            Text(project.name).tag(project.name as String?)
                        }
                        
                    }
                    HStack{
                        Button("Create New Project", systemImage: "plus") { }
                    }
                }
                .padding()
                .frame(width: 300)
            }
        }
}
