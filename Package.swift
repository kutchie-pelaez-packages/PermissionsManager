// swift-tools-version:5.3.0

import PackageDescription

let package = Package(
    name: "PermissionsManager",
    platforms: [
        .iOS("15")
    ],
    products: [
        .library(
            name: "PermissionsManagerImpl",
            targets: [
                "PermissionsManagerImpl"
            ]
        ),
        .library(
            name: "PermissionsManagerTweaking",
            targets: [
                "PermissionsManagerTweaking"
            ]
        ),
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
        .package(name: "Tweaking", url: "https://github.com/kutchie-pelaez-packages/Tweaking.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "PermissionsManagerImpl",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "Logger", package: "Logging"),
                .product(name: "Tweaking", package: "Tweaking"),
                .target(name: "PermissionsManager"),
                .target(name: "PermissionsManagerTweaking")
            ]
        ),
        .target(
            name: "PermissionsManagerTweaking",
            dependencies: [
                .product(name: "Tweaking", package: "Tweaking"),
                .target(name: "PermissionsManager")
            ]
        ),
        .target(name: "PermissionsManager")
    ]
)
