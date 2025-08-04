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
import FoundationModels
import Model

@MainActor
public struct SessionController {
  
  public enum Status: Equatable {
    case isReset, isStarted, isResponding
  }
  
  @Binding private var model: ChatDocModel
  private var session: LanguageModelSession?
  
  public var status: Status {
    if let session {
      return session.isResponding ? .isResponding : .isStarted
    } else {
      return .isReset
    }
  }
  
  public init(_ model: Binding<ChatDocModel>) {
    _model = model
  }
  
  public mutating func startSession() {
    let instructions = self.model.options.sessionOptions.instructions
    self.model.records.append(Entry.started(instructions).toRecord())
    self.session = LanguageModelSession(model: .default, instructions: instructions)
  }
  
  public mutating func resetSession() {
    self.model.records.append(Entry.reset.toRecord())
    self.session = nil
  }
  
  public func prompt(_ prompt: String) {
    let session = self.session!
    self.model.records.append(Entry.message(.init(prompt, isUser: true)).toRecord())
    let response = self.newResponseBinding()
    Task {
      do {
        for try await token in session.streamResponse(to: prompt) {
          response.wrappedValue.entry.stringValue += token
        }
      } catch {
        response.wrappedValue.entry = .error(String(describing: error))
      }
    }
  }
  
  private func newResponseBinding() -> Binding<EntryRecord> {
    self.model.records.append(Entry.message(.init("", isUser: false)).toRecord())
    return $model.records.last!
  }
}
