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
import UniformTypeIdentifiers
import Model

public struct ChatDoc: FileDocument {
  
  public static let defaultModel = ChatDocModel(config:DocConfig(sessionOptions:SessionOptions(instructions:"You are a friendly chatbot that talks with the user. You can format your messages with Markdown as they will be formatted for the user. Please have a good time and keep things light and funny.")))
  
  public static let readableContentTypes = [
    UTType(exportedAs: "com.saturdayapps.ChatDocs.document")
  ]
  
  public var model: ChatDocModel
  
  public init(_ model: ChatDocModel = ChatDoc.defaultModel) {
    self.model = model
  }
  
  public init(configuration: ReadConfiguration) throws {
    let plistDecoder = PropertyListDecoder()
    guard let data = configuration.file.regularFileContents else {
      throw CocoaError(.fileReadCorruptFile)
    }
    let model = try plistDecoder.decode(ChatDocModel.self, from: data)
    self.model = model
  }
  
  public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    let plistEncoder = PropertyListEncoder()
    let data = try plistEncoder.encode(self.model)
    return .init(regularFileWithContents: data)
  }
}
