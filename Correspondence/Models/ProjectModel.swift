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
    var location: String
    var createdAt: Date
    var conversation: Conversation?

    init( name: String, location: String, conversation: Conversation? = nil) {
        self.id = UUID()
        self.name = name
        self.location = location
        self.createdAt = Date()
        self.conversation = conversation
    }
}
