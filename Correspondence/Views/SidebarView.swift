//
//  SidebarView.swift
//  Correspondence
//
//  Created by Phillip Johnson on 9/5/25.
//

import SwiftUI

struct SidebarView: View {
    @Binding var selectedSidebar: SidebarItem?
    @Environment(\.openSettings) private var openSettings

    var body: some View {
        List(selection: $selectedSidebar) {
            Label("Chats", systemImage: "bubble.left.and.bubble.right")
                .tag(SidebarItem.chats)
            Label("Agents", systemImage: "person.bubble")
                .tag(SidebarItem.agents)
            Label("Projects", systemImage: "folder")
                .tag(SidebarItem.projects)
            Button {
                openSettings()
            } label: {
                Label("Settings", systemImage: "gear")
            }
            .buttonStyle(.plain)
        }
        .navigationTitle("Browse")
    }
}

