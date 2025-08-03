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
import Model

internal struct InspectorView: View {
  
  @Binding private var session: LanguageModelSession?
  @Binding private var config: DocConfig
  
  internal init(config: Binding<DocConfig>,
                session: Binding<LanguageModelSession?>)
  {
    _session = session
    _config = config
  }
  
  internal var body: some View {
    Form {
      Section("Current Session") {
        LabeledContent("Instructions") {
          TextEditor(text: $config.sessionOptions.instructions)
        }
        Toggle("Include Transcripts", isOn: $config.sessionOptions.usesTranscripts)
        Button("Start Session") {
          self.session = LanguageModelSession(model: .default, instructions: self.config.sessionOptions.instructions)
        }
      }
      .disabled(self.session != nil)
      Section("Reset Session") {
        Button("Reset Session") {
          self.session = nil
        }
      }
      .disabled(self.session == nil)
    }
  }
}
