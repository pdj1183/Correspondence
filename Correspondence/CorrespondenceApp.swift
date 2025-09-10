//
//  CorrespondenceApp.swift
//  Correspondence
//
//  Created by Phillip Johnson on 7/2/25.
//

import SwiftUI
import SwiftData

@main
struct CorrespondenceApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Conversation.self,
            Message.self,
            Agent.self,
            Project.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(ColorScheme.dark)
        }
        .modelContainer(sharedModelContainer)
        #if os(macOS)
            Settings {
                SettingsView()
                    .preferredColorScheme(ColorScheme.dark)
            }
        #endif
    }
    
}
