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
import Controller

public struct ChatDocView: View {
  
  @Binding internal var document: ChatDoc
  
  public init(document: Binding<ChatDoc> = .constant(.init())) {
    _document = document
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      EntryListView(self.document.model.records)
        .safeAreaInset(edge: .bottom, spacing: 0) {
          GlassEffectContainer {
            EntryEmitterView() {
              self.document.model.records.append($0)
            }
            .padding()
            .frame(minWidth: 320, maxWidth: 640)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
          }
          .padding([.leading, .trailing, .bottom], 8)
        }
    }
  }
}

#Preview {
  ChatDocView()
}
