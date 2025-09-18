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
    @StateObject var models: GlobalModels = GlobalModels()
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
    
    @AppStorage("appearance") private var appearance: String = "System"

    var body: some Scene {
            WindowGroup {
                ContentView()
                    .environmentObject(models)
                    .preferredColorScheme(colorScheme(from: appearance))
            }
            .modelContainer(sharedModelContainer)
            #if os(macOS)
            Settings {
                SettingsView()
                    .environmentObject(models)
                    .preferredColorScheme(colorScheme(from: appearance))
            }
            #endif
        }

        private func colorScheme(from appearance: String) -> ColorScheme? {
            switch appearance {
            case "Light":
                return .light
            case "Dark":
                return .dark
            default:
                return nil // "System" → follow system setting
            }
        }
    }

class GlobalModels: ObservableObject {
    @Published var models = ["gpt-5", "gpt-4", "gpt-5-nano", "gpt-4o", "gpt-4o-mini", "gpt-5-mini"]
}
