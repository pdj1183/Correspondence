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
    var model: String?
    var agent: Agent?

    // Relationships
    @Relationship(deleteRule: .cascade) var messages: [Message] = []
    var project: Project?

    init() {
        self.id = UUID()
        self.title = "New Conversation"
        self.createdAt = Date()
        self.updatedAt = Date()
        self.messages = []
        self.agent = nil
        self.project = nil
        self.model = ""
    }

    convenience init(title: String, project: Project? = nil, agents: Agent? = nil, model: String? = nil) {
        self.init()
        self.title = title
        self.project = project
        self.agent = agents
        self.model = model
    }
}
