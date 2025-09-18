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

    // One-to-many: an agent can have multiple conversations
    @Relationship() var conversations: [Conversation] = []

    var model: String
    var parameters: [String: String]

    init() {
        self.id = UUID()
        self.name = ""
        self.prompt = ""
        self.desc = nil
        self.createdAt = Date()
        self.model = ""
        self.parameters = [:]
    }

    convenience init(
        name: String,
        prompt: String,
        desc: String? = nil,
        model: String = "",
        parameters: [String: String] = [:]
    ) {
        self.init()
        self.name = name
        self.prompt = prompt
        self.desc = desc
        self.model = model
        self.parameters = parameters
    }
}
