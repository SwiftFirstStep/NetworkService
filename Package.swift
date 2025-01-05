// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.


import PackageDescription

let package = Package(
    name: "NetworkService",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "NetworkService",
            targets: ["NetworkService"]
        ),
    ],
    targets: [
        .target(
            name: "NetworkService",
            dependencies: [],
            path: "Sources/NetworkService"
        ),
        .testTarget(
            name: "NetworkServiceTests",
            dependencies: ["NetworkService"],
            path: "Tests/NetworkServiceTests"
        ),
    ]
)
