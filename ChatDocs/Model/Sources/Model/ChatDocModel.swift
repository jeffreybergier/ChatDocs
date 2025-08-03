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

public struct ChatDocModel: Equatable, Codable, Sendable {
  
  public var records: [EntryRecord] = []
  public var config: DocConfig = .init()
  
  public init(_ records: [EntryRecord] = []) {
    self.records = records
  }
  public mutating func process(record: EntryRecord) {
    if let lastRecord = self.records.last, lastRecord.id == record.id {
      self.records[self.records.count-1] = record
    } else {
      self.records.append(record)
    }
  }
}

public enum Entry: Equatable, Codable, Sendable {
  
  case message(Message)
  case reset
  case started(String)
  case error(String)
  
  public func toRecord() -> EntryRecord {
    return .init(entry: self)
  }
  
  public var stringValue: String {
    get {
      switch self {
      case .message(let message):
        return message.content
      case .started(let content), .error(let content):
        return content
      default:
        return ""
      }
    }
    set {
      switch self {
      case .message(var message):
        message.content = newValue
        self = .message(message)
      case .started:
        self = .started(newValue)
      case .error:
        self = .error(newValue)
      default:
        break
      }
    }
  }
}

public struct EntryRecord: Equatable, Codable, Sendable, Identifiable {
  
  public var id: String = UUID().uuidString
  public var date: Date = .now
  public var entry: Entry
  
  public init(id: String = UUID().uuidString,
              date: Date = .now,
              entry: Entry)
  {
    self.id = id
    self.date = date
    self.entry = entry
  }
}

public struct Message: Equatable, Codable, Sendable {
  public struct Options: Equatable, Codable, Sendable {
    public enum Mode: Equatable, Codable, Sendable {
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
  
  public var content: String = ""
  public var options: Options = .init()
  public var isUser: Bool = true
  public init(_ content: String = "",
              options: Options = .init(),
              isUser: Bool = true)
  {
    self.content = content
    self.options = options
    self.isUser = isUser
  }
}

public struct DocConfig: Equatable, Codable, Sendable {
  public var promptOptions: PromptOptions?
  public var sessionOptions: SessionOptions
  public init(promptOptions: PromptOptions? = nil,
              sessionOptions: SessionOptions = .init())
  {
    self.promptOptions = promptOptions
    self.sessionOptions = sessionOptions
  }
}

public struct SessionOptions: Equatable, Codable, Sendable {
  public var instructions: String
  public var usesTranscripts: Bool
  public init(instructions: String = "",
              usesTranscripts: Bool = true)
  {
    self.instructions = instructions
    self.usesTranscripts = usesTranscripts
  }
}

public struct PromptOptions: Equatable, Codable, Sendable {
  public var sampling: PromptMode
  public var temperature: Double
  public var minimumResponseTokens: Int
  public init(sampling: PromptMode,
              temperature: Double,
              minimumResponseTokens: Int)
  {
    self.sampling = sampling
    self.temperature = temperature
    self.minimumResponseTokens = minimumResponseTokens
  }
}

public enum PromptMode: Equatable, Codable, Sendable {
  case greedy
  case randomP(probabilityThreshold: Double, seed: UInt64?)
  case randomT(top: Int, seed: UInt64?)
}
