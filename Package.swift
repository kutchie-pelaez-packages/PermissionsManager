// swift-tools-version:5.3.0

import PackageDescription

let package = Package(
    name: "PermissionsManager",
    platforms: [
        .iOS("15")
    ],
    products: [
        .library(
            name: "PermissionsManager",
            targets: [
                "PermissionsManager"
            ]
        )
    ],
    dependencies: [
        .package(name: "Core", url: "https://github.com/kutchie-pelaez-packages/Core.git", .branch("master")),
        .package(name: "Logging", url: "https://github.com/kutchie-pelaez-packages/Logging.git", .branch("master")),
        .package(name: "Tweaks", url: "https://github.com/kutchie-pelaez-packages/Tweaks.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "PermissionsManager",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "Logger", package: "Logging"),
                .product(name: "Tweak", package: "Tweaks")
            ],
            path: "Sources"
        )
    ]
)
