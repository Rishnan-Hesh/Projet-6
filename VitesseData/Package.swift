// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "VitesseData",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "VitesseData", targets: ["VitesseData"]),
    ],
    dependencies: [
        .package(path: "../VitesseDomain")
    ],
    targets: [
        .target(
            name: "VitesseData",
            dependencies: ["VitesseDomain"]
        ),
        .testTarget(
            name: "VitesseDataTests",
            dependencies: ["VitesseData"]
        ),
    ]
)
