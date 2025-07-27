//
//  ChatDocsApp.swift
//  ChatDocs
//
//  Created by Me on 2025/07/27.
//

import SwiftUI
import View

@main
struct App: SwiftUI.App {
  var body: some Scene {
    DocumentGroup(newDocument: ChatDocsDocument()) { file in
      ContentView(document: file.$document)
    }
  }
  
  func doSomething() {
    let myView: MyView = MyView()
  }
}
