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

internal struct EntryInputView: View {
  
  @State private var session: LanguageModelSession? = nil
  @State private var noAIError: SystemLanguageModel.Availability.UnavailableReason?
  @SceneStorage("Prompt") private var prompt: String = ""
  @SceneStorage("Instructions") private var instructions: String = "You are a friendly chatbot. Please have an engaging and insightful discussion with the user"
  @SceneStorage private var mode: Mode
  private let entryEmitter: (Entry) -> Void
  
  private var canPrompt: Bool {
    if let session {
      return session.isResponding == false
    } else {
      return false
    }
  }
    
  internal init(__PREVIEWS: Mode = .reset, _ onEntry: @escaping (Entry) -> Void) {
    _mode = .init(wrappedValue: __PREVIEWS, "Prompt")
    self.entryEmitter = onEntry
  }
  
  internal var body: some View {
    VStack {
      if let noAIError {
        // TODO: Localize Error Reasons
        Text(String(describing: noAIError))
      } else {
        switch self.mode {
        case .reset:
          HStack {
            TextEditor(text: self.instructionBinding)
              .frame(maxHeight: 64)
              .disabled(self.session != nil)
            VStack {
              Button("Clear Session") {
                self.session = nil
                self.entryEmitter(.init(kind: .reset))
              }
              .disabled(self.session == nil)
              Button("Start Session") {
                let instructions = self.instructions
                self.session = LanguageModelSession(instructions: instructions)
                self.entryEmitter(.init(kind: .started(instructions)))
              }
              .disabled(self.session != nil)
            }
          }
        case .prompt:
          HStack {
            TextEditor(text: self.$prompt)
              .frame(maxHeight: 64)
            Button {
              let prompt = self.prompt
              self.entryEmitter(.init(kind: .message(.init(text: prompt, isUser: true))))
              Task {
                do {
                  let response = try await self.session!.respond(to: prompt)
                  self.entryEmitter(.init(kind: .message(.init(text: response.content, isUser: false))))
                  self.prompt = ""
                } catch let error {
                  self.entryEmitter(.init(kind: .error(String(describing:error))))
                }
              }
            } label: {
              Label("Ask", systemImage: "checkmark")
                .font(.title)
                .padding(4)
            }
            .tint(.green)
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.circle)
          }
          .disabled(!self.canPrompt)
        }
      }
      Picker("", selection: $mode) {
        ForEach(Mode.allCases) { mode in
          Text(mode.label)
            .tag(mode)
        }
      }
      .pickerStyle(.palette)
    }
    .font(.body)
    .animation(.default, value: self.mode)
    .onAppear {
      #if !DEBUG
      let availability = SystemLanguageModel.default.availability
      switch availability {
      case .available:
        self.noAIError = nil
      case .unavailable(let reason):
        self.noAIError = reason
      }
      #endif
    }
  }
  
  private var instructionBinding: Binding<String> {
    return .init {
      if let _ = self.session {
        return "Clear Session to Set New Instructions"
      } else {
        return self.instructions
      }
    } set: {
      self.instructions = $0
    }
  }
  
  internal enum Mode: String, RawRepresentable, CaseIterable, Identifiable {
    case reset, prompt
    internal var id: String { self.rawValue }
    internal var label: LocalizedStringKey {
      switch self {
      case .prompt:
        return "Session"
      case .reset:
        return "Prompt"
      }
    }
  }
}

#Preview {
  EntryInputView(__PREVIEWS: .reset) { _ in }
  EntryInputView(__PREVIEWS: .prompt) { _ in }
}
