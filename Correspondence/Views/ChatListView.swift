import SwiftUI
import SwiftData

struct ChatListView: View {
    @EnvironmentObject var GlobalModels: GlobalModels
    @Environment(\.modelContext) private var modelContext
    @Binding var selectedConversation: Conversation?
    @Binding var searchText: String
    var conversations: [Conversation]
    var filteredConversations: [Conversation]
    var addConversation: () -> Void
    var addAgent: () -> Void
    var showModelPopup: Binding<Bool>
    var showAgentPopup: Binding<Bool>
    var showProjectPopup: Binding<Bool>
    var selectedConversationForPopups: Conversation?
    
    var deleteItems: (IndexSet) -> Void

    var body: some View {
        List(selection: $selectedConversation) {
            ForEach(filteredConversations) { convo in
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
            .onDelete(perform: deleteItems)
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
                Button { showModelPopup.wrappedValue = true } label: {
                    Label("Model", systemImage: "brain")
                }
                .popover(isPresented: showModelPopup) {
                    if let conversation = selectedConversationForPopups {
                        ModelPickerView(conversation: conversation)
                    }
                }
                .disabled(selectedConversationForPopups == nil)
                
                Button { showAgentPopup.wrappedValue = true } label: {
                    Label("Agent", systemImage: "person.bubble")
                }
                .popover(isPresented: showAgentPopup) {
                    if let conversation = selectedConversationForPopups {
                        AgentPickerView(conversation: conversation, addAgent: addAgent)
                    }
                }
                .disabled(selectedConversationForPopups == nil)
                
                Button { showProjectPopup.wrappedValue = true } label: {
                    Label("Project", systemImage: "folder")
                }
                .popover(isPresented: showProjectPopup) {
                    if let conversation = selectedConversationForPopups {
                        ProjectPickerView(conversation: conversation)
                    }
                }
                .disabled(selectedConversationForPopups == nil)
            }
        }
    }
}
