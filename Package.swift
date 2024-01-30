// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BaatoSwift",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BaatoSwift",
            targets: ["BaatoSwift"]),
    ],
    dependencies: [
            .package(url: "https://github.com/bemohansingh/swift-networking", from: "1.0.0"),
                   .package(url: "https://github.com/GEOSwift/GEOSwift", from: "10.1.0"),
          
       ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BaatoSwift",
        dependencies: [
            .product(name: "GEOSwift", package: "geoswift"),
            .product(name: "SwiftNetworking", package: "swift-networking")
        ]),
        .testTarget(
            name: "BaatoSwiftTests",
            dependencies: ["BaatoSwift"]),
    ]
)
