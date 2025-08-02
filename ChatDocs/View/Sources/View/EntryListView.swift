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

#if os(macOS)
import AppKit
extension Color {
  internal static var controlTextColor: Color { Color(nsColor: .textBackgroundColor) }
  internal static var systemGreen: Color { Color(nsColor: .systemGreen) }
  internal static var systemBlue: Color { Color(nsColor: .systemBlue) }
  internal static var systemGray: Color { Color(nsColor: .systemGray) }
}
#else
import UIKit
extension Color {
  internal static var controlTextColor: Color { Color(uiColor: .label) }
  internal static var systemGreen: Color { Color(uiColor: .systemGreen) }
  internal static var systemBlue: Color { Color(uiColor: .systemBlue) }
  internal static var systemGray: Color { Color(uiColor: .systemGray) }
}
#endif

internal struct EntryListView: View {
  
  private let records: [EntryRecord]
  
  internal init(_ records: [EntryRecord]) {
    self.records = records
  }
  internal var body: some View {
    List(self.records) { record in
      EntryListRowView(record)
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
        self.chatBubble(message.content)
        if (!message.isUser) {
          Spacer()
        }
      }
    case .reset:
      self.chatBubble("Chat Session Reset")
    case .started(let instructions):
      self.chatBubble(instructions, explanation: "Chat Session Started")
    case .error(let error):
      self.chatBubble(error, explanation: "Chat Session Error")
    }
  }
  
  private func chatBubble(_ text: String,
                          explanation: String? = nil)
                          -> some View
  {
    return VStack(alignment:.leading) {
      if let explanation {
        Text(explanation)
          .font(.callout)
        Divider().frame(maxWidth: 300)
      }
      if let markdown = self.renderMarkdown(text) {
        Text(markdown)
          .font(.body)
      } else {
        Text(text)
          .font(.body)
      }
    }
    .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
    .foregroundStyle(Color.controlTextColor)
    .background(self.backgroundColor)
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .shadow(radius: 2)
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
  
  private func renderMarkdown(_ text: String) -> AttributedString? {
    let options = AttributedString.MarkdownParsingOptions(interpretedSyntax:.inlineOnly)
    let output = try? AttributedString(markdown:text, options: options)
    return output
  }
  
  // TODO: Figure out why I cannot use full
}

#Preview {
  List {
    EntryListRowView(Entry.started("You are a friendly chatbot").toRecord())
    EntryListRowView(Entry.reset.toRecord())
    EntryListRowView(Entry.error("Out of Tokens").toRecord())
    EntryListRowView(Entry.message(.init("This is **cool** don't you think?")).toRecord())
    EntryListRowView(Entry.message(.init("This is **cool** don't you think?", isUser: false)).toRecord())
    EntryListRowView(Entry.message(.init("""
                                       # Title One
                                       
                                       This is **cool** don't you think?
                                       
                                       - List Item 1
                                       - List Item 2
                                       - List Item 3
                                       
                                       ## Subsection One
                                       
                                       This is cool
                                       """, isUser: false)).toRecord())
  }
}
