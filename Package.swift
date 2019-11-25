// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Typographizer",
    platforms: [
        .iOS(.v10),
        .macOS("10.10"),
        .watchOS(.v3),
        .tvOS(.v10)
    ],
    products: [
        .library(
            name: "Typographizer",
            targets: ["Typographizer"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Typographizer",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "TypographizerTests",
            dependencies: ["Typographizer"],
            path: "TypographizerTests"),
    ],
    swiftLanguageVersions: [.v4, .v5]
)
