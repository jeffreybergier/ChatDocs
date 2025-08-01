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

internal struct EntryListView: View {
  private let entries: [Entry]
  
  internal init(_ entries: [Entry]) {
    self.entries = entries
  }
  internal var body: some View {
    List(self.entries) { entry in
      EntryListRowView(entry)
        .listRowSeparator(.hidden)
    }
  }
}

internal struct EntryListRowView: View {
  
  private let entry: Entry
  
  internal init(_ entry: Entry) {
    self.entry = entry
  }
  
  internal var body: some View {
    switch self.entry.kind {
    case .none:
      Spacer()
      Text("None")
      Spacer()
    case .message(let message):
      HStack(spacing: 0) {
        if (message.isUser) {
          Spacer()
        }
        Text(message.text)
          .font(.body)
          .foregroundStyle(Color.white)
          .padding()
          .glassEffect(
            .regular.tint(message.isUser ? .green : .blue), in: .rect(cornerRadius: 16)
          )
          .animation(.bouncy, value: message.text)
      }
    }
  }
}

#Preview {
  let messages: [Message] = [
    .init(text: "Can you tell me about the great wall?"),
    .init(text: "Sure, the great wall is a blah blah blah blah.", isUser: false),
    .init(text: "Oh, thats so cool! I didn't know that. But what is a blah?"),
    .init(text: "A blah is a small mouse that lives in the wall. Its really cute! Do you want to know more?", isUser: false),
    .init(text: "Yes"),
    .init(text: "Great,222 let me tell you more...", isUser: false),
  ]
  let entries: [Entry] = messages.map { Entry(kind: .message($0)) }
  EntryListView(entries)
}
