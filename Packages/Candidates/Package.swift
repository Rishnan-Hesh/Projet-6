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
        .package(path: "../VitesseDomain"),
        .package(path: "../VitesseData")
    ],
    
    targets: [
        
        .target(
            name: "Candidates",
            dependencies: ["VitesseDomain", "VitesseData"]
        ),
        
            .testTarget(
                name: "CandidateTests",
                dependencies: ["Candidates","VitesseDomain","VitesseData"]),
        
        
            .testTarget(
                name: "CandidateDetailsTests",
                dependencies: ["Candidates","VitesseDomain","VitesseData"]
            )
        
    ]
)
