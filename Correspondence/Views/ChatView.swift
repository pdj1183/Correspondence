//
//  ChatView.swift
//  Correspondence
//
//  Created by Phillip Johnson on 8/29/25.
//

import SwiftUI
import SwiftData

struct ChatView: View {
    @Environment(\.modelContext) private var modelContext
    let conversation: Conversation

    @State private var inputText: String = ""

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(conversation.messages.sorted(by: { $0.createdAt < $1.createdAt })) { message in
                            MessageRow(message: message)
                                .id(message.id)
                        }
                    }
                    .onChange(of: conversation.messages.count) {
                        if let last = conversation.messages.last {
                            withAnimation {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                Divider()
                
                HStack {
                    
                    ZStack() {
                        TextEditor(text: $inputText)
                            .font(Font.body.monospacedDigit())
                            .frame(minHeight: 50, maxHeight: geometry.size.height * 0.4)
                            .padding(4)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.gray.opacity(0.5))
                            )
                            .fixedSize(horizontal: false, vertical: true)
                            .cornerRadius(8)
                        if inputText == "" {
                            Text("Type a message…")
                                .foregroundColor(.secondary)
                        }
                    }
                    Button("Send") {
                        addMessage()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(ControlSize.large)
                    .tint(inputText.isEmpty ? .davySGravy :.accentColor)
                    .disabled(inputText.isEmpty)
                }
                
                .padding()
            }
            .navigationTitle(conversation.title)
        }
    }

    private func addMessage() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let msg = Message(role: "user", content: trimmed, conversation: conversation)
        conversation.messages.append(msg)
        conversation.updatedAt = Date()
        modelContext.insert(msg)
        inputText = ""
    }
}


#Preview("ChatView") {
    let container = try! ModelContainer(for: Conversation.self, Message.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = container.mainContext

    let convo = Conversation(title: "Preview Chat")
    let m1 = Message(role: "assistant", content: "Hello! How can I help you today?", conversation: convo)
    let m2 = Message(role: "user", content: "Show me a sample chat.", conversation: convo)
    convo.messages.append(contentsOf: [m1, m2])
    convo.updatedAt = Date()

    context.insert(convo)

    return NavigationStack {
        ChatView(conversation: convo)
    }
    .modelContainer(container)
}
