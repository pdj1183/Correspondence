//
//  ConversationModel.swift
//  Correspondence
//
//  Created by Phillip Johnson on 8/29/25.
//

import SwiftData
import Foundation

@Model
class Conversation {
    var id: UUID
    var title: String
    var createdAt: Date
    var updatedAt: Date
    @Relationship(deleteRule: .cascade) var messages: [Message] = []

    init(title: String) {
        self.id = UUID()
        self.title = title
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
