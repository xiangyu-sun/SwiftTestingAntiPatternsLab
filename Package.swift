// swift-tools-version: 6.0
import PackageDescription

let package = Package(
  name: "SwiftTestingAntiPatternsLab",
  platforms: [.macOS(.v13)],
  products: [
    .library(name: "AntiPatternsLab", targets: ["AntiPatternsLab"])
  ],
  targets: [
    .target(name: "AntiPatternsLab"),
    .testTarget(name: "AntiPatternsLabTests", dependencies: ["AntiPatternsLab"])
  ],
  swiftLanguageModes: [.v6]
)
