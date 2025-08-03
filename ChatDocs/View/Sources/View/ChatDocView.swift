//
// GPLv3 License Notice
//
// Copyright (c) 2025 Jeffrey Bergier
//
// This file is part of ChatDocs.
// ChatDocs is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published
// by the Free Software Foundation, either version 3 of the License,
// or (at your option) any later version.
// ChatDocs is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License
// along with ChatDocs. If not, see <https://www.gnu.org/licenses/>.
//

import SwiftUI
import FoundationModels
import Controller

public struct ChatDocView: View {
  
  @State private var session: LanguageModelSession?
  @Binding internal var document: ChatDoc
  @SceneStorage("Inspector") private var showsInspector = false
  
  public init(document: Binding<ChatDoc> = .constant(.init())) {
    _document = document
  }
  
  public var body: some View {
    RecordListView(self.document.model.records)
      .safeAreaInset(edge: .bottom, spacing: 0) {
        ChatView($session) { newRecord in
          self.document.model.process(record: newRecord)
        }
        .padding([.leading, .trailing, .bottom], 8)
      }
      .inspector(isPresented:$showsInspector) {
        InspectorView(config:$document.model.config, session:$session)
      }
      .toolbar(id: "Toolbar") {
        ToolbarItem(id: "Chat", placement: .automatic) {
          Button("Toggle Chat") {
            
          }
        }
        ToolbarItem(id: "Inspector", placement: .automatic) {
          Button("Toggle Inspector") {
            self.showsInspector.toggle()
          }
        }
      }
  }
}

#Preview {
  ChatDocView()
}
