//
//  ContentView.swift
//  ChatDocs
//
//  Created by Me on 2025/07/27.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: ChatDocsDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

#Preview {
    ContentView(document: .constant(ChatDocsDocument()))
}
