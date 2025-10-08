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
        .package(path: "../CandidatesPCK")
    ],
    targets: [
        .target(
            name: "Authentication",
            dependencies: ["VitesseDomain", "CandidatesPCK"]
        ),
        .testTarget(
            name: "AuthenticationTests",
            dependencies: ["Authentication", "VitesseDomain", "CandidatesPCK"]
        ),
        .testTarget(
            name: "RegisterTests",
            dependencies: ["Authentication", "VitesseDomain", "CandidatesPCK"]
        )
    ]
)

