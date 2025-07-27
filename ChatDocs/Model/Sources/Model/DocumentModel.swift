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

import Foundation
import FoundationModels

public struct DocumentModel: Codable, Sendable {
  public var messages: [Message]
  public var configuration: Configuration
  public init(messages: [Message] = [],
              configuration: Configuration = .init())
  {
    self.messages = messages
    self.configuration = configuration
  }
}

extension DocumentModel {
  public struct Message: Codable, Sendable, Identifiable {
    public var id: String
    public var text: AttributedString
    public var date: Date
    public var isUser: Bool
    public init(id: String = UUID().uuidString,
                text: AttributedString = "",
                date: Date = .now,
                isUser: Bool = true)
    {
      self.id = id
      self.text = text
      self.date = date
      self.isUser = isUser
    }
  }
  public struct Configuration: Codable, Sendable {
    public var instructions: String
    public init(instructions: String = "") {
      self.instructions = instructions
    }
  }
}
