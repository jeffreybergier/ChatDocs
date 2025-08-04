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

internal struct InspectorView: View {
  
  @Binding private var controller: SessionController
  @Binding private var config: Options
  
  internal init(config: Binding<Options>,
                session controller: Binding<SessionController>)
  {
    _config = config
    _controller = controller
  }
  
  internal var body: some View {
    Form {
      Section("Current Session") {
        VStack(alignment:.leading) {
          Text("Instructions")
          CD_TextEditor(self.$config.sessionOptions.instructions)
        }
        .disabled(self.controller.status != .isReset)
        Picker("Include Transcript", selection:self.$config.sessionOptions.transcriptOptions) {
          Text("None").tag(TranscriptOptions.none)
          Text("All").tag(TranscriptOptions.all)
          Text("Selected").tag(TranscriptOptions.selected)
        }
        .disabled(self.controller.status != .isReset)
        HStack {
          Button("Start Session") {
            self.controller.startSession()
          }
          .disabled(self.controller.status != .isReset)
          Button("Reset Session") {
            self.controller.resetSession()
          }
          .disabled(self.controller.status != .isStarted)
        }
      }
    }
  }
}
