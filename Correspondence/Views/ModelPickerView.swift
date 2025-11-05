//
//  ModelPickerView.swift
//  Correspondence
//
//  Created as part of refactoring ContentColumnView.
//

import SwiftUI

struct ModelPickerView: View {
    @EnvironmentObject var GlobalModels: GlobalModels
    @Bindable var conversation: Conversation

    var body: some View {
        VStack {
            Text("Select Model").font(.headline)
            Picker("Model", selection: $conversation.model) {
                ForEach(GlobalModels.models, id: \.self) { model in
                    Text(model).tag(model as String?)
                }
            }
        }
        .padding()
        .frame(width: 300)
    }
}
