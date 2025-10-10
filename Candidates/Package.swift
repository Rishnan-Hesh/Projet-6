// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "Candidates",
    platforms: [.iOS(.v17)],
    products: [
        
        .library(
            name: "Candidates",
            targets: ["Candidates"]),
    ],
    
    dependencies: [
        .package(path: "../VitesseDomain")
    ],
    
    targets: [
        
        .target(
            name: "Candidates",
            dependencies: ["VitesseDomain"]
        ),
        
            .testTarget(
                name: "CandidateTests",
                dependencies: ["Candidates","VitesseDomain"]),
        
        
            .testTarget(
                name: "CandidateDetailsTests",
                dependencies: ["Candidates","VitesseDomain"]
            )
        
    ]
)
