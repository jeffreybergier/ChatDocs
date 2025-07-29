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

public struct ChatDocModel: Codable, Sendable {
  public var entries: [Entry] = []
  public init(_ entries: [Entry] = []) {
    self.entries = entries
  }
}

public struct Entry: Codable, Sendable, Identifiable {
  public enum Kind: Codable, Sendable {
    case none
    case message(Message)
  }
  
  public var id: String = UUID().uuidString
  public var date: Date = .now
  public var kind: Kind = .none
  
  public init(id: String = UUID().uuidString,
              date: Date = .now,
              kind: Kind = .none)
  {
    self.id = id
    self.date = date
    self.kind = kind
  }
}

public struct Message: Codable, Sendable {
  public struct Options: Codable, Sendable {
    public enum Mode: Codable, Sendable {
      case greedy
      case randomP(probabilityThreshold: Double, seed: UInt64?)
      case randomT(top: Int, seed: UInt64?)
    }
    public var sampling: Mode?
    public var temperature: Double?
    public var minimumResponseTokens: Int?
    public init(sampling: Mode? = nil,
                temperature: Double? = nil,
                minimumResponseTokens: Int? = nil)
    {
      self.sampling = sampling
      self.temperature = temperature
      self.minimumResponseTokens = minimumResponseTokens
    }
  }
  
  public var text: String = ""
  public var options: Options = .init()
  public var isUser: Bool = true
  public init(text: String = "",
              options: Options = .init(),
              isUser: Bool = true)
  {
    self.text = text
    self.options = options
    self.isUser = isUser
  }
}
