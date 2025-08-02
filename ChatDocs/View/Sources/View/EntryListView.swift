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
  
  private let records: [EntryRecord]
  
  internal init(_ records: [EntryRecord]) {
    self.records = records
  }
  internal var body: some View {
    List(self.records) { entry in
      EntryListRowView(entry)
        .listRowSeparator(.hidden)
    }
  }
}

internal struct EntryListRowView: View {
  
  private let record: EntryRecord
  
  internal init(_ record: EntryRecord) {
    self.record = record
  }
  
  internal var body: some View {
    switch self.record.entry {
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
    case .reset:
      Text("Session Cleared")
    case .started(let instructions):
      Text("Sesssion Started")
      Text(instructions)
    case .error(let error):
      Text("Sesssion Started")
      Text(error)
    }
  }
  
  private var backgroundColor: AnyGradient {
    switch self.record.entry {
    case .message(let message) where message.isUser:
      return Color.green.gradient
    case .message:
      return Color.blue.gradient
    default:
      return Color.gray.gradient
    }
  }
}

#Preview {
  let messages: [Message] = [
    Message(text: "Can you tell me about the great wall?"),
//    Message(text: "Sure, the great wall is a blah blah blah blah.", isUser: false),
//    .init(text: "Oh, thats so cool! I didn't know that. But what is a blah?"),
//    .init(text: "A blah is a small mouse that lives in the wall. Its really cute! Do you want to know more?", isUser: false),
//    .init(text: "Yes"),
//    .init(text: "Great,222 let me tell you more...", isUser: false),
  ]
  let records: [EntryRecord] = messages.map { Entry.message($0).toRecord() }
  EntryListView(records)
}
