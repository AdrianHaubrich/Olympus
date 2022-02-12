// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Olympus",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        // Olympus Library
        .library(
            name: "Olympus",
            targets: ["Olympus"]),
        
        // Charon Library
        .library(
            name: "Charon",
            targets: ["Charon"]),
        
        // Helena Library
        .library(
            name: "Helena",
            targets: ["Helena"]),
        
        // Hermes Library
        .library(
            name: "Hermes",
            targets: ["Hermes"]),
        
        // Prometheus Library
        .library(
            name: "Prometheus",
            targets: ["Prometheus"]),
        
        // Prometheus Firestore Library
        .library(
            name: "PrometheusFirestore",
            targets: ["PrometheusFirestore"]),
        
        // Zeus Library
        .library(
            name: "Zeus",
            targets: ["Zeus"]),
    ],
    dependencies: [
        // Firebase
        .package(name: "Firebase",
                 url: "https://github.com/firebase/firebase-ios-sdk.git",
                 from: "8.0.0")
    ],
    targets: [
        // Olympus Targets
        .target(
            name: "Olympus",
            dependencies: []),
        .testTarget(
            name: "OlympusTests",
            dependencies: ["Olympus"]),
        
        // Charon Target
        .target(
            name: "Charon",
            dependencies: [
                // Firebase
                .product(name: "FirebaseAuth", package: "Firebase"),
                .product(name: "FirebaseFirestore", package: "Firebase"),
                .product(name: "FirebaseFirestoreSwift-Beta", package: "Firebase")
            ]),
        
        // Helena Target
        .target(
            name: "Helena",
            dependencies: ["Prometheus"]),
        
        // Hermes Target
        .target(
            name: "Hermes",
            dependencies: [
                // First-Party
                "Helena",
                "Prometheus",
                
                // Firebase
                .product(name: "FirebaseAuth", package: "Firebase"),
                .product(name: "FirebaseFirestore", package: "Firebase"),
                .product(name: "FirebaseFirestoreSwift-Beta", package: "Firebase"),
                .product(name: "FirebaseStorage", package: "Firebase"),
                .product(name: "FirebaseStorageSwift-Beta", package: "Firebase")
            ]),
        
        // Prometheus Target
        .target(
            name: "Prometheus",
            dependencies: []),
        
        // Prometheus Target
        .target(
            name: "PrometheusFirestore",
            dependencies: [
                // Firebase
                .product(name: "FirebaseFirestore", package: "Firebase"),
                .product(name: "FirebaseFirestoreSwift-Beta", package: "Firebase")
            ]),
        
        // Zeus Target
        .target(
            name: "Zeus",
            dependencies: []),
        
    ]
)
