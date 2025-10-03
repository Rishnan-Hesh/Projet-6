// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "Candidats",
    platforms: [.iOS(.v17)],
    products: [

        .library(
            name: "Candidates",
            targets: ["Candidates", "CandidateDetails"]),
    ],
    targets: [
        
            .target(
            name: "Candidates"),
        
            .target(
                name: "CandidateDetails"),
        
        .testTarget(
            name: "CandidatesTests",
            dependencies: ["Candidates"]),
        
        
        .testTarget(
            name: "CandidateDetailsTests",
            dependencies: ["CandidateDetails"]
        ),
    ]
)
