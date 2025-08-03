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

typealias RecordEmitter = (EntryRecord) -> Void

@MainActor
func CD_PrimaryButton(_ title: LocalizedStringKey,
                      disabled: Bool = false,
                      action: @escaping ()->Void)
                      -> some View
{
  return Button(action: action) {
    Label(title, systemImage: "checkmark")
      .font(.title)
      .padding(4)
  }
  .tint(.green)
  .buttonStyle(.glassProminent)
  .buttonBorderShape(.circle)
  .disabled(disabled)
}

func CD_TextEditor(_ text: Binding<String>) -> some View {
  return VStack(alignment:.leading) {
    TextEditor(text: text)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .overlay {
        RoundedRectangle(cornerRadius: 8)
          .stroke(Color.gray.opacity(0.4), lineWidth: 1)
      }
  }
  .frame(maxHeight: 64)
}

internal struct PromptView: View {
    
  @Binding private var controller: SessionController
  
  internal init(session controller: Binding<SessionController>) {
    _controller = controller
  }
  
  internal var body: some View {
    GlassEffectContainer {
      Group {
        switch SystemLanguageModel.default.availability {
        case .available:
          ChatPromptView($controller)
        case .unavailable(let reason):
          Label(String(describing: reason), systemImage: "triangle.exclamationmark")
            .font(.title)
        }
      }
      .padding()
      .frame(minWidth: 320, maxWidth: 640)
      .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
    }
  }
}

internal struct ChatPromptView: View {
  
  @SceneStorage("Prompt") private var prompt = ""
  @Binding private var controller: SessionController
  
  internal init(_ controller: Binding<SessionController>) {
    _controller = controller
  }
  
  internal var body: some View {
    VStack {
      HStack(alignment:.top) {
        CD_TextEditor(self.$prompt)
        CD_PrimaryButton("Ask",
                         disabled:self.controller.status == .isResponding
                               || self.prompt == "")
        {
          self.controller.prompt(self.prompt)
          self.prompt = ""
        }
      }
    }
  }
}

#Preview {
  ChatPromptView(.constant(SessionController(.constant(.init()))))
}
