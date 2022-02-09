// swift-tools-version:5.3.0

import PackageDescription

let package = Package(
    name: "AccessManager",
    platforms: [
        .iOS("15")
    ],
    products: [
        .library(
            name: "AccessManager", 
            targets: [
                "AccessManager"
            ]
        )
    ],
    dependencies: [
        .package(name: "Core", url: "https://github.com/kutchie-pelaez-packages/Core.git", .branch("master")),
        .package(name: "Logging", url: "https://github.com/kutchie-pelaez-packages/Logging.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "AccessManager",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "Logger", package: "Logging")
            ],
            path: "Sources"
        )
    ]
)
