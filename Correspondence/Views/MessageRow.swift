//
//  MessageRow.swift
//  Correspondence
//
//  Created by Phillip Johnson on 8/29/25.
//

import SwiftUI
import SwiftData

struct MessageRow: View {
    let message: Message

    var body: some View {
        if #available(macOS 26.0, *) {
            HStack {
                if message.role == "user" {
                    Spacer()
                    Text(message.content)
                        .padding()
                        .glassEffect(.regular.tint(Color.atomicTangerine.opacity(0.75)), in: .rect(cornerRadius: 16.0))
                        .frame(maxWidth: 250, alignment: .trailing)
                } else {
                    Text(message.content)
                        .padding()
                        .glassEffect( in: .rect(cornerRadius: 16.0) )
                        .frame(maxWidth: 250, alignment: .leading)
                    Spacer()
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
                    } else {
            HStack {
                if message.role == "user" {
                    Spacer()
                    Text(message.content)
                        .padding()
                        .background(Color.userChat.opacity(0.8))
                        .cornerRadius(12)
                        .frame(maxWidth: 250, alignment: .trailing)
                } else {
                    Text(message.content)
                        .padding()
                        .background(Color.aiChat.opacity(0.8))
                        .cornerRadius(12)
                        .frame(maxWidth: 250, alignment: .leading)
                    Spacer()
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
        }
    }
}

#Preview("MessageRow - User") {
    let container = try! ModelContainer(for: Conversation.self, Message.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let convo = Conversation(title: "Preview")
    let msg = Message(role: "user", content: "Hello", conversation: convo)
    return MessageRow(message: msg)
        .modelContainer(container)
}

#Preview("MessageRow - Assistant") {
    let container = try! ModelContainer(for: Conversation.self, Message.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let convo = Conversation(title: "Preview")
    let msg = Message(role: "assistant", content: "Hi there!", conversation: convo)
    return MessageRow(message: msg)
        .modelContainer(container)
}
