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
  internal static var controlTextColor: Color { Color(nsColor: .labelColor) }
  internal static var controlColor: Color { Color(nsColor: .controlColor) }
  internal static var systemGreen: Color { Color(nsColor: .systemGreen) }
  internal static var systemBlue: Color { Color(nsColor: .systemBlue) }
  internal static var systemGray: Color { Color(nsColor: .systemGray) }
  internal static var systemYellow: Color { Color(nsColor: .systemYellow) }
}
#else
import UIKit
extension Color {
  internal static var controlTextColor: Color { Color(uiColor: .label) }
  internal static var controlColor: Color { Color(uiColor: .secondarySystemBackground) }
  internal static var systemGreen: Color { Color(uiColor: .systemGreen) }
  internal static var systemBlue: Color { Color(uiColor: .systemBlue) }
  internal static var systemGray: Color { Color(uiColor: .systemGray) }
  internal static var systemYellow: Color { Color(uiColor: .systemYellow) }
}
#endif

internal struct RecordView: View {
  
  private let records: [EntryRecord]
  
  internal init(records: [EntryRecord]) {
    self.records = records
  }
  internal var body: some View {
    ScrollViewReader { proxy in
      List(self.records) { record in
        RecordCellView(record)
          .listRowSeparator(.hidden)
      }
      .listStyle(.plain)
      .onChange(of: self.records.last) { _, last in
        guard let last else { return }
        withAnimation {
          proxy.scrollTo(last.id, anchor: .bottom)
        }
      }
    }
  }
}

internal struct RecordCellView: View {
  
  private let record: EntryRecord
  
  internal init(_ record: EntryRecord) {
    self.record = record
  }
  
  internal var body: some View {
    switch self.record.entry {
    case .message(let message):
      HStack(spacing:0) {
        if (message.isUser) {
          Spacer()
        }
        self.chatBubble(message.content)
          .animation(.default, value: message.content)
        if (!message.isUser) {
          Spacer()
        }
      }
    case .reset:
      HStack(spacing:0) {
        Spacer()
        self.chatBubble("Chat Session Reset")
        Spacer()
      }
    case .started(let instructions):
      HStack(spacing:0) {
        Spacer()
        self.chatBubble(instructions, explanation: "Chat Session Started")
        Spacer()
      }
    case .error(let error):
      HStack(spacing:0) {
        Spacer()
        self.chatBubble(error, explanation: "Chat Session Error")
        Spacer()
      }
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
      return Color.systemGreen.gradient
    case .message:
      return Color.systemBlue.gradient
    case .error:
      return Color.systemYellow.gradient
    default:
      return Color.systemGray.gradient
    }
  }
  
  private func renderMarkdown(_ text: String) -> AttributedString? {
    let options = AttributedString.MarkdownParsingOptions(interpretedSyntax:.inlineOnlyPreservingWhitespace)
    let output = try? AttributedString(markdown:text, options: options)
    return output
  }
  
  // TODO: Figure out why I cannot use full
}

#Preview {
  List {
    RecordCellView(Entry.started("You are a friendly chatbot").toRecord())
    RecordCellView(Entry.reset.toRecord())
    RecordCellView(Entry.error("Out of Tokens").toRecord())
    RecordCellView(Entry.message(.init("This is **cool** don't you think?")).toRecord())
    RecordCellView(Entry.message(.init("This is **cool** don't you think?", isUser: false)).toRecord())
    RecordCellView(Entry.message(.init("""
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
