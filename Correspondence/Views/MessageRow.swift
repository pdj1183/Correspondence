//
//  MessageRow.swift
//  Correspondence
//
//  Created by Phillip Johnson on 8/29/25.
//

import SwiftUI
import SwiftData
import AppKit

struct MessageRow: View {
    @Bindable var message: Message
    @State private var isEditing = false
    @State private var isHovered = false

    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.clear)
                .contentShape(Rectangle())
            if #available(macOS 26.0, *) {
                HStack {
                    if message.role == "user" {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 0) {
                            if isEditing {
                                TextEditor(text: $message.content)
                                    .font(Font.body.monospacedDigit())
                                    .frame(maxWidth: 800, alignment: .trailing)
                                    .scrollContentBackground(.hidden)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.black.opacity(0.3))
                                            .padding(EdgeInsets(top: -8, leading: -8, bottom: -8, trailing: -8))
                                    )
                                    .padding()
                                    .glassEffect(.regular.tint(Color.atomicTangerine.opacity(0.75)), in: .rect(cornerRadius: 16.0))
                            } else {
                                Text(message.content)
                                    .padding()
                                    .glassEffect(.regular.tint(Color.atomicTangerine.opacity(0.75)), in: .rect(cornerRadius: 16.0))
                                    .frame(maxWidth: 800, alignment: .trailing)
                                    .textSelection(.enabled)
                            }
                                ZStack{
                                    if isHovered {
                                        HStack {
                                            Button(isEditing ? "Cancel" :"Copy", systemImage: isEditing ? "xmark" : "doc.on.clipboard", role: isEditing ? .destructive : nil) {
                                                if isEditing { isEditing.toggle() }
                                                else {
                                                    NSPasteboard.general.clearContents()
                                                    NSPasteboard.general.setString(message.content, forType: .string)
                                                }
                                            }
                                            .labelStyle(.iconOnly)
                                            
                                            Button(isEditing ? "Send"  : "Edit", systemImage: isEditing ? "arrow.up.message"  : "bubble.and.pencil") {
                                                isEditing.toggle()
                                            }
                                            .labelStyle(.iconOnly)
                                        }
                                    } else {
                                        Text(message.createdAt, style: .time)
                                    }
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 0, height: 35)
                                }
                            
                            
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(message.content)
                                .padding()
                                .glassEffect(in: .rect(cornerRadius: 16.0))
                                .frame(maxWidth: 800, alignment: .leading)
                                .textSelection(.enabled)
                            ZStack{
                                if isHovered {
                                    HStack {
                                        Button("Copy", systemImage: "doc.on.clipboard") {
                                            NSPasteboard.general.clearContents()
                                            NSPasteboard.general.setString(message.content, forType: .string)
                                        }
                                        .labelStyle(.iconOnly)
                                        
                                    }
                                    .font(.caption)
                                    .padding(.top, 4)
                                    .frame(maxWidth: 800, alignment: .leading)
                                }
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 0, height: 35)
                            }
                        }
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
                .padding(.horizontal)
                .padding(.vertical, 4)
                .onHover { hovering in
                    isHovered = hovering
                }
            } else {
                HStack {
                    if message.role == "user" {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 0) {
                            if isEditing {
                                TextEditor(text: $message.content)
                                    .font(Font.body.monospacedDigit())
                                    .frame(maxWidth: 800, alignment: .trailing)
                                    .scrollContentBackground(.hidden)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.black.opacity(0.3))
                                            .padding(EdgeInsets(top: -8, leading: -8, bottom: -8, trailing: -8))
                                    )
                                        .padding()
                                    .background(Color.userChat.opacity(0.8))
                                    .cornerRadius(12)
                            } else {
                                Text(message.content)
                                    .padding()
                                    .background(Color.userChat.opacity(0.8))
                                    .cornerRadius(12)
                                    .frame(maxWidth: 800, alignment: .trailing)
                                    .textSelection(.enabled)
                            }
                            ZStack{
                                if isHovered {
                                    HStack {
                                        Button(isEditing ? "Cancel" :"Copy", systemImage: isEditing ? "xmark" : "doc.on.clipboard", role: isEditing ? .destructive : nil) {
                                            if isEditing { isEditing.toggle() }
                                            else {
                                                NSPasteboard.general.clearContents()
                                                NSPasteboard.general.setString(message.content, forType: .string)
                                            }
                                        }
                                        .labelStyle(.iconOnly)
                                        
                                        Button(isEditing ? "Send"  : "Edit", systemImage: isEditing ? "arrow.up.message"  : "bubble.and.pencil") {
                                            isEditing.toggle()
                                        }
                                        .labelStyle(.iconOnly)
                                    }
                                }
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 0, height: 35)
                            }
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(message.content)
                                .padding()
                                .background(Color.aiChat.opacity(0.8))
                                .cornerRadius(12)
                                .frame(maxWidth: 800, alignment: .leading)
                                .textSelection(.enabled)
                            ZStack{
                                if isHovered {
                                    HStack {
                                        Button("Copy", systemImage: "doc.on.clipboard") {
                                            NSPasteboard.general.clearContents()
                                            NSPasteboard.general.setString(message.content, forType: .string)
                                        }
                                        .labelStyle(.iconOnly)
                                    }
                                }
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 0, height: 35)
                            }
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 4)
                .onHover { hovering in
                    isHovered = hovering
                }
            }
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
