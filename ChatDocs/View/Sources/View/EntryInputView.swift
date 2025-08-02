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
import Model
import FoundationModels

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

func CD_TextEditor(_ titleKey: LocalizedStringKey,
                   disabled: Bool,
                   text: Binding<String>)
                   -> some View
{
  return VStack(alignment:.leading) {
    // TODO: Figure out how to disable the text editor
    VStack(alignment:.leading) {
      TextEditor(text: text)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        }
      Text(titleKey)
        .font(.caption)
        .foregroundStyle(Color.gray)
    }
  }
  .frame(maxHeight: 64)
}

internal struct EntryEmitterView: View {
    
  @State private var session: LanguageModelSession?
  
  private let emitter: RecordEmitter
  internal init(_ onEntry: @escaping RecordEmitter) {
    self.emitter = onEntry
  }
  
  internal var body: some View {
    GlassEffectContainer {
      Group {
        if let session {
          EntryEmitterPromptView(session: session, onEntry: self.emitter)
        } else {
          switch SystemLanguageModel.default.availability {
          case .available:
            EntryEmitterSessionView(session: $session, onEntry: self.emitter)
          case .unavailable(let reason):
            Label(String(describing: reason), systemImage: "triangle.exclamationmark")
              .font(.title)
          }
        }
      }
      .padding()
      .frame(minWidth: 320, maxWidth: 640)
      .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
    }
  }
}

internal struct EntryEmitterSessionView: View {
  
  @Binding private var session: LanguageModelSession?
  @SceneStorage("Instructions") private var instructions: String = "You are a friendly chatbot. Please have an engaging and insightful discussion with the user"

  private let emitter: RecordEmitter
  internal init(session: Binding<LanguageModelSession?>,
                onEntry: @escaping RecordEmitter)
  {
    _session = session
    self.emitter = onEntry
  }
  
  internal var body: some View {
    HStack(alignment: .top) {
      CD_TextEditor("Start your chat session with some instructions",
                    disabled:self.session != nil,
                    text:$instructions)
        .frame(maxHeight: 64)
        .font(.body)
      CD_PrimaryButton("Start", disabled:self.session != nil) {
        let instructions = self.instructions
        self.session = LanguageModelSession(instructions: instructions)
        self.emitter(Entry.started(instructions).toRecord())
      }
    }
  }
}

internal struct EntryEmitterPromptView: View {
  
  @SceneStorage("Prompt") private var prompt = ""
  @State private var response = Entry.message(.init("", isUser: false)).toRecord()
  
  private let session: LanguageModelSession
  private let emitter: RecordEmitter
  internal init(session: LanguageModelSession, onEntry: @escaping RecordEmitter) {
    self.session = session
    self.emitter = onEntry
  }
  
  internal var body: some View {
    VStack {
      HStack(alignment:.top) {
        CD_TextEditor("Ask the model anything you like",
                      disabled:self.session.isResponding,
                      text:$prompt)
        CD_PrimaryButton("Ask", disabled:self.session.isResponding) {
          Task {
            do {
              let prompt = self.prompt
              self.response = Entry.message(.init("", isUser: false)).toRecord()
              self.prompt = ""
              self.emitter(Entry.message(.init(prompt, isUser: true)).toRecord())
              for try await token in self.session.streamResponse(to: prompt) {
                self.response.entry.stringValue += token
                self.emitter(self.response)
              }
              self.response = Entry.message(.init("", isUser: false)).toRecord()
            } catch let error {
              self.emitter(Entry.error(String(describing: error)).toRecord())
            }
          }
        }
      }
    }
    .animation(.default, value:self.response.entry.stringValue)
  }
}

#Preview {
  EntryEmitterSessionView(session: .constant(nil), onEntry: { _ in })
  EntryEmitterPromptView(session: .init(model:.default), onEntry: { _ in })
}
