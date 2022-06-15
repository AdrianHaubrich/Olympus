// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Olympus",
    platforms: [.iOS(.v15), .watchOS(.v7)/*, .macOS(.v12)*/],
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
        
        // MacOS Compatibility Library
        .library(
            name: "MacOSCompatibility",
            targets: ["MacOSCompatibility"]),
        
        // Prometheus Library
        .library(
            name: "Prometheus",
            targets: ["Prometheus"]),
        
        // Prometheus Firebase Storage
        .library(
            name: "PrometheusFirebaseStorage",
            targets: ["PrometheusFirebaseStorage"]),
        
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
                 from: "9.1.0")
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
                // First-Party
                "MacOSCompatibility",
                
                // Firebase
                .product(name: "FirebaseAuth", package: "Firebase"),
                .product(name: "FirebaseFirestore", package: "Firebase"),
                .product(name: "FirebaseFirestoreSwift", package: "Firebase")
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
                "Charon",
                "Prometheus",
                "PrometheusFirebaseStorage",
                "PrometheusFirestore",
                "MacOSCompatibility",
                
                // Firebase
                .product(name: "FirebaseAuth", package: "Firebase"), // TODO: Remove
                .product(name: "FirebaseFirestore", package: "Firebase"),
                .product(name: "FirebaseFirestoreSwift", package: "Firebase")
            ]),
        
        // MacOSCompatibility Target
        .target(
            name: "MacOSCompatibility",
            dependencies: []),
        
        // Prometheus Target
        .target(
            name: "Prometheus",
            dependencies: [
                // First Party
                "MacOSCompatibility"
            ]),
        
        // Prometheus Firebase Storage Target
        .target(
            name: "PrometheusFirebaseStorage",
            dependencies: [
                // First-Party
                "Prometheus",
                "MacOSCompatibility",
                
                // Firebase
                .product(name: "FirebaseStorage", package: "Firebase"),
                .product(name: "FirebaseStorageCombine-Community", package: "Firebase")
            ]),
        
        // Prometheus Firestore Target
        .target(
            name: "PrometheusFirestore",
            dependencies: [
                // First-Party
                "MacOSCompatibility",
                
                // Firebase
                .product(name: "FirebaseFirestore", package: "Firebase"),
                .product(name: "FirebaseFirestoreSwift", package: "Firebase")
            ]),
        
        // Zeus Target
        .target(
            name: "Zeus",
            dependencies: []),
        
    ]
)
