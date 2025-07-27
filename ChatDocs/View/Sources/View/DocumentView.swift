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

public struct DocumentView: View {
  
  @Binding internal var document: Document
  @SceneStorage("prompt") internal var prompt: String = ""
  
  public init(document: Binding<Document> = .constant(.init())) {
    _document = document
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      List(self.document.model.messages) { message in
        HStack {
          if (message.isUser) {
            Spacer()
          }
          Text(message.text)
        }
      }
      HStack {
        TextField("Enter Prompt", text: self.$prompt)
        Button("Submit") {
          // TODO: Hook this up to the LLM
          self.document.model.messages.append(.init(text: .init(self.prompt)))
          self.prompt = ""
        }
      }
      .padding()
    }
  }
}

import Model

#Preview {
  let model = DocumentModel(messages:[
    .init(text: "Can you tell me about the great wall?"),
    .init(text: "Sure, the great wall is a blah blah blah blah.", isUser: false),
    .init(text: "Oh, thats so cool! I didn't know that. But what is a blah?"),
    .init(text: "A blah is a small mouse that lives in the wall. Its really cute! Do you want to know more?", isUser: false),
    .init(text: "Yes"),
    .init(text: "Great, let me tell you more...", isUser: false),
  ])
  DocumentView(document: .constant(Document(model: model)))
}
