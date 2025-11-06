// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "Authentication",
    platforms: [.iOS(.v17)],
    products: [
        
        .library(
            name: "Authentication",
            targets: ["Authentication"]
        ),
    ],
    dependencies: [
        .package(path: "../VitesseDomain"),
        .package(path: "../Candidates"),
        .package(path: "../VitesseData")
    ],
    targets: [
        .target(
            name: "Authentication",
            dependencies: ["VitesseDomain", "Candidates", "VitesseData"]
        ),
        .testTarget(
            name: "AuthenticationTests",
            dependencies: ["Authentication", "VitesseDomain", "Candidates"]
        ),
        .testTarget(
            name: "RegisterTests",
            dependencies: ["Authentication", "VitesseDomain", "Candidates", "VitesseData"]
        )
    ]
)

