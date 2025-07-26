//
//  ChatDocsApp.swift
//  ChatDocs
//
//  Created by Me on 2025/07/27.
//

import SwiftUI

@main
struct ChatDocsApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: ChatDocsDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
