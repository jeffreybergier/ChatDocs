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
  
  internal enum Mode: String, RawRepresentable {
    case reset, prompt
  }
  
  @State private var noAIError: SystemLanguageModel.Availability.UnavailableReason?
  @SceneStorage("Prompt") private var prompt: String = ""
  @SceneStorage("Mode") private var mode: Mode = .reset
    
  internal init() { }
  
  internal var body: some View {
    Group {
      if let noAIError {
        // TODO: Localize Error Reasons
        Text(String(describing: noAIError))
      } else {
        switch self.mode {
        case .reset:
          // TODO: Add instructions entering
          // TODO: Add use cases?
          // TODO: Add button to create session
          Text("Reset")
        case .prompt:
          TextField("What do you want to ask?", text: self.$prompt)
        }
      }
    }
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
}

#Preview {
  EntryInputView()
}
