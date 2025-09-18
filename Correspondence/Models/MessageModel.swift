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

    init() {
        self.id = UUID()
        self.role = "user"
        self.content = ""
        self.createdAt = Date()
        self.conversation = nil
    }

    convenience init(role: String, content: String, conversation: Conversation?) {
        self.init()
        self.role = role
        self.content = content
        self.conversation = conversation
    }
}
