//
//  AgentModel.swift
//  Correspondence
//
//  Created by Phillip Johnson on 9/5/25.
//

import Foundation
import SwiftData

@Model
class Agent {
    var id: UUID
    var name: String
    var prompt: String
    var desc: String?
    var createdAt: Date
    var updatedAt: Date?
    var conversation: Conversation?

    init( name: String, prompt: String, desc: String? = nil, conversation: Conversation? = nil) {
        self.id = UUID()
        self.name = name
        self.prompt = prompt
        self.desc = desc
        self.createdAt = Date()
        self.conversation = conversation
    }
}
