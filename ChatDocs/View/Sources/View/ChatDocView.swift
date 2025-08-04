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
import Model

public struct ChatDocView: View {
  
  @Binding private var document: ChatDoc
  
  @State private var controller: SessionController
  @State private var session: LanguageModelSession?
  @SceneStorage("Inspector") private var isPresentingInspector = false
  @SceneStorage("RecordEdit") private var isEditingRecords = false
  
  // TODO: Add this for iOS
  //@Environment(\.editMode) private var editMode
  
  public init(document: Binding<ChatDoc> = .constant(.init())) {
    _document = document
    _controller = .init(initialValue: .init(document.model))
  }
  
  public var body: some View {
    RecordView(records:self.document.model.records,
               selection:self.$document.model.options.sessionOptions.transcriptSelection)
      .safeAreaInset(edge: .bottom, spacing: 0) {
        PromptView(session:self.$controller)
          .padding([.leading, .trailing, .bottom], 8)
      }
      .inspector(isPresented:self.$isPresentingInspector) {
        InspectorView(config:self.$document.model.options,
                      session:self.$controller)
      }
      .toolbar(id: "Toolbar") {
        ToolbarItem(id: "Edit", placement: .automatic) {
          Button("Deselect All") {
            self.document.model.options.sessionOptions.transcriptSelection = []
          }
          .disabled(self.document.model.options.sessionOptions.transcriptSelection.isEmpty)
        }
        ToolbarItem(id: "Inspector", placement: .automatic) {
          Button("Toggle Inspector") {
            self.isPresentingInspector.toggle()
          }
        }
      }
  }
}

#Preview {
  ChatDocView()
}
