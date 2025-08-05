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

// TODO: For some reason, when I edit the EditMode environment
// value in this view, it is not passed down to the list view.
// I think this is a bug in SwiftUI for iOS26
private struct HACK_EditMode: EnvironmentKey {
  static let defaultValue: Bool = false
}

extension EnvironmentValues {
  var HACK_editMode: Bool {
    get { self[HACK_EditMode.self] }
    set { self[HACK_EditMode.self] = newValue }
  }
}

public struct ChatDocView: View {
  
  @Binding private var document: ChatDoc
  
  @State private var controller: SessionController
  @State private var session: LanguageModelSession?
  @State private var hack_editMode = false
  @SceneStorage("Inspector") private var isPresentingInspector = false
  
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
    .environment(\.HACK_editMode, self.hack_editMode)
    .toolbar(id:"Toolbar") {
      ToolbarItem(id:"Delete") {
        Button(role: .destructive) {
          self.document.model.deleteSelectedRecords()
        } label: {
          Label("Delete", systemImage: "trash.circle")
        }
        .disabled(self.document.model.options.sessionOptions.transcriptSelection.isEmpty)
      }
      ToolbarItem(id:"Select") {
        self.selectButton
      }
      ToolbarItem(id:"Inspector") {
        Button {
          self.isPresentingInspector.toggle()
        } label: {
          Label("Inspector", systemImage: "sidebar.right")
        }
      }
    }
  }
  
  @ViewBuilder private var selectButton: some View {
    if
      self.document.model.options.sessionOptions.transcriptSelection.isEmpty,
      self.hack_editMode == false
    {
      Button {
        self.hack_editMode = true
        self.document.model.options.sessionOptions.transcriptSelection = Set(self.document.model.records.map { $0.id})
      } label: {
        Label("Select All", systemImage: "checkmark.circle")
      }
    } else {
      Button {
        self.hack_editMode = false
        self.document.model.options.sessionOptions.transcriptSelection = []
      } label: {
        Label("Deselect All", systemImage: "circle.dashed")
      }
    }
  }
}

#Preview {
  ChatDocView()
}
