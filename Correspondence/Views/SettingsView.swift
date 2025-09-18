//
//  SettingsView.swift
//  Correspondence
//
//  Created by Phillip Johnson on 9/5/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var GlobalModels: GlobalModels
    @AppStorage("openAIKey") private var openAIKey: String = ""
    @AppStorage("anthropicKey") private var anthropicKey: String = ""
    @AppStorage("saveLocation") private var saveLocation: String = "~/Documents/Correspondence/Chats"
    @AppStorage("appearance") private var appearance: String = "System"
    @AppStorage("defaultModel") private var defaultModel: String = "gpt-4"
    
    let appearances = ["System", "Light", "Dark"]

    var body: some View {
        Form {
            Section(header: Text("Chat Storage")) {
                HStack {
                    Text("Save Location")
                    Spacer()
                    TextField("", text: $saveLocation)
                        .multilineTextAlignment(.trailing)
                        .textSelection(.enabled)
                }
            }
            
            Section(header: Text("API Keys")) {
                SecureField("OpenAI API Key", text: $openAIKey)
                SecureField("Anthropic API Key", text: $anthropicKey)
            }
            
            Section(header: Text("Appearance")) {
                Picker("Preferred Appearance", selection: $appearance) {
                    ForEach(appearances, id: \.self) { style in
                        Text(style).tag(style)
                    }
                }
                .pickerStyle(.radioGroup)
            }
            
            Section(header: Text("Default Model")) {
                Picker("Default Model", selection: $defaultModel) {
                    ForEach(GlobalModels.models, id: \.self) { model in
                        Text(model).tag(model)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    SettingsView()
}
