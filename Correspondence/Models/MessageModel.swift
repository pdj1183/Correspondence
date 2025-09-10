//
//  MessageModel.swift
//  Correspondence
//
//  Created by Phillip Johnson on 8/29/25.
//

import SwiftData
import Foundation

@Model
class Message {
    var id: UUID
    var role: String   // "user" or "assistant"
    var content: String
    var createdAt: Date
    var conversation: Conversation?

    init(role: String, content: String, conversation: Conversation) {
        self.id = UUID()
        self.role = role
        self.content = content
        self.createdAt = Date()
        self.conversation = conversation
    }
}
