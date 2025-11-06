// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "VitesseDomain",
    platforms: [.iOS(.v17)],
    products: [

        .library(
            name: "VitesseDomain",
            targets: ["VitesseDomain"]),
    ],
    
    dependencies: [
        .package(path: "../VitesseData")],
        
    targets: [

        .target(
            name: "VitesseDomain"),
        
        .testTarget(
            name: "VitesseDomainTests",
            dependencies: ["VitesseDomain"]
        )
    ]
)
