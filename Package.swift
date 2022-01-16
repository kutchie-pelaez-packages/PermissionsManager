// swift-tools-version:5.3.0

import PackageDescription

let package = Package(
    name: "AccessManager",
    platforms: [
        .iOS("15")
    ],
    products: [
        .library(name: "AccessManager", targets: ["AccessManager"])
    ],
    dependencies: [
        .package(name: "CoreUtils", url: "https://github.com/kutchie-pelaez-packages/CoreUtils", .branch("master"))
    ],
    targets: [
        .target(
            name: "AccessManager",
            dependencies: [
                .product(name: "CoreUtils", package: "CoreUtils")
            ],
            path: "Sources"
        )
    ]
)
