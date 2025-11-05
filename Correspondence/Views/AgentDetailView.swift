//
//  AgentDetailForm.swift
//  Correspondence
//
//  Created by Phillip Johnson on 9/18/25.
//

import SwiftUI

struct AgentDetailForm: View {
    @EnvironmentObject var GlobalModels: GlobalModels
    @Bindable var agent: Agent
    
    var body: some View {
        Form {
            Section(header: Text("Basic Info")) {
                TextField("Name", text: $agent.name)
                TextField("Prompt", text: $agent.prompt, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
                TextField("Description", text: $agent.desc, axis: .vertical)
                    .lineLimit(2, reservesSpace: true)
            }
            
            Section(header: Text("Model Settings")) {
                Picker("Model", selection: $agent.model) {
                    ForEach(GlobalModels.models, id: \.self) { model in
                        Text(model).tag(model as String?)
                    }
                }
            }
            
            Section(header: Text("Parameters")) {
                ForEach(Array(agent.parameters.keys), id: \.self) { key in
                    HStack {
                        Text(key)
                        Spacer()
                        TextField("Value", text: Binding(
                            get: { agent.parameters[key] ?? "" },
                            set: { agent.parameters[key] = $0 }
                        ))
                    }
                }
                Button(action: {
                    agent.parameters["newKey"] = ""
                }) {
                    Label("Add Parameter", systemImage: "plus.circle")
                }
            }
        }
        .padding()
        .frame(minWidth: 400, minHeight: 400)
    }
}

#Preview {
    let agent = Agent(
        name: "Research Assistant",
        prompt: "You are a helpful assistant.",
        desc: "General purpose AI agent for research and summaries.",
        model: "gpt-4",
        parameters: [
            "temperature": "0.7",
            "max_tokens": "2048"
        ]
    )
    AgentDetailForm(agent: agent)
        .environmentObject(GlobalModels())
}
