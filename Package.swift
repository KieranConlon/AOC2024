// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "aoc2024",
    platforms: [.macOS(.v15)],
    dependencies: [
      .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
      .package(url: "https://github.com/firecrestHorizon/PerformanceTimer.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "aoc2024",
            dependencies: [
              .product(name: "ArgumentParser", package: "swift-argument-parser"),
              .product(name: "PerformanceTimer", package: "PerformanceTimer")
            ]
        ),
    ]
)
