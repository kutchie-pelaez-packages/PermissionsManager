// swift-tools-version:5.3.0

import PackageDescription

let name: String = "AccessManager"

let remoteDependencies = [
    "CoreUtils",
]

let package = Package(
    name: name,
    platforms: [
        .iOS("15")
    ],
    products: [
        .library(name: name, targets: [name])
    ],
    dependencies: remoteDependencies.map {
        .package(name: $0, url: "https://github.com/kutchie-pelaez/\($0)", .branch("master"))
    },
    targets: [
        .target(
            name: name,
            dependencies: remoteDependencies.map {
                .product(name: $0, package: $0)
            },
            path: "Sources"
        )
    ]
)
