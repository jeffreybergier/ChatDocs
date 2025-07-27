// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Model",
  products: [
    .library(
      name: "Model",
      targets: ["Model"]
    ),
  ],
  targets: [
    .target(
      name: "Model"
    ),
  ],
  swiftLanguageModes: [.v6]
)
