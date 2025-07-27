// swift-tools-version: 6.2

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

import PackageDescription

let package = Package(
  name: "View",
  platforms: [
    .macOS(.v12),
    .iOS(.v15),
  ],
  products: [
    .library(
      name: "View",
      targets: ["View"]
    ),
  ],
  dependencies: [
    .package(path: "../Controller"),
  ],
  targets: [
    .target(
      name: "View",
      dependencies: [
        .byNameItem(name: "Controller", condition: nil),
      ],
    ),
  ],
  swiftLanguageModes: [.v6]
)
