//
//  ProjectModel.swift
//  Correspondence
//
//  Created by Phillip Johnson on 9/5/25.
//

import SwiftData
import Foundation

@Model
class Project {
    var id: UUID
    var name: String
    var locations: [String]   // multiple directories or repo paths
    var metadata: [String: String] // flexible key/value for project info
    var createdAt: Date

    // Relationships
    @Relationship(inverse: \Conversation.project) var conversations: [Conversation] = []

    // Default initializer
    init() {
        self.id = UUID()
        self.name = ""
        self.locations = []
        self.metadata = [:]
        self.createdAt = Date()
        self.conversations = []
    }

    // Convenience initializer
    convenience init(name: String, locations: [String], metadata: [String: String] = [:]) {
        self.init()
        self.name = name
        self.locations = locations
        self.metadata = metadata
    }
}
