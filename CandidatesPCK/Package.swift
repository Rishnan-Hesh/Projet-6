// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "CandidatesPCK",
    platforms: [.iOS(.v17)],
    products: [
        
        .library(
            name: "CandidatesPCK",
            targets: ["CandidatesPCK"]),
    ],
    
    dependencies: [
        .package(path: "../VitesseDomain")
    ],
    
    targets: [
        
        .target(
            name: "CandidatesPCK",
            dependencies: ["VitesseDomain"]
        ),
        
            .testTarget(
                name: "CandidateTests",
                dependencies: ["CandidatesPCK","VitesseDomain"]),
        
        
            .testTarget(
                name: "CandidateDetailsTests",
                dependencies: ["CandidatesPCK","VitesseDomain"]
            )
        
    ]
)
