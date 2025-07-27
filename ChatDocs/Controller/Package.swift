// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Controller",
  products: [
    .library(
      name: "Controller",
      targets: ["Controller"]
    ),
  ],
  dependencies: [
    .package(path: "../Model"),
  ],
  targets: [
    .target(
      name: "Controller",
      dependencies: [
        .byNameItem(name: "Model", condition: nil),
      ],
    ),
  ],
  swiftLanguageModes: [.v6]
)
