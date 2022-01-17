// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "IOUtility",
  products: [
    .library(name: "BitReader", targets: ["BitReader"]),
    .library(name: "IOModule", targets: ["IOModule"]),
  ],
  dependencies: [
     .package(url: "https://github.com/kojirou1994/Endianness.git", from: "1.0.0"),
     .package(url: "https://github.com/apple/swift-system.git", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "BitReader",
      dependencies: [
        .product(name: "Endianness", package: "Endianness"),
        .product(name: "SystemPackage", package: "swift-system"),
      ]),
    .target(
      name: "IOModule",
      dependencies: [
        "BitReader",
        .product(name: "Endianness", package: "Endianness"),
        .product(name: "SystemPackage", package: "swift-system"),
      ]),
    .target(
      name: "IOStreams",
      dependencies: [
        "IOModule",
      ]),
    .testTarget(
      name: "IOModuleTests",
      dependencies: ["IOModule", "IOStreams"]),
  ]
)
