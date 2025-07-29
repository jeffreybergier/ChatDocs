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
import FoundationModels

public struct ChatDocView: View {
  
  @Binding internal var document: ChatDoc
  
  public init(document: Binding<ChatDoc> = .constant(.init())) {
    _document = document
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      List(self.document.model.entries) { message in
        // TODO: Create EntryListView
      }
      // TODO: Create EntryInputView
    }
  }
}

import Model

#Preview {
  let messages: [Message] = [
    .init(text: "Can you tell me about the great wall?"),
    .init(text: "Sure, the great wall is a blah blah blah blah.", isUser: false),
    .init(text: "Oh, thats so cool! I didn't know that. But what is a blah?"),
    .init(text: "A blah is a small mouse that lives in the wall. Its really cute! Do you want to know more?", isUser: false),
    .init(text: "Yes"),
    .init(text: "Great, let me tell you more...", isUser: false),
  ]
  let model = ChatDocModel(messages.map { Entry(kind: .message($0)) })
  ChatDocView(document: .constant(ChatDoc(model)))
}
