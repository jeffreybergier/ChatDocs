// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "View",
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
