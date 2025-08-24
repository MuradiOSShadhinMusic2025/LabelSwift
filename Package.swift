// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LabelSwift",
    platforms: [
        .iOS(.v13)
    ],
    
    products: [
        .library(
            name: "LabelSwift",
            targets: ["LabelSwift"]
        ),
    ],
    
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.6.0"),
        .package(url: "https://github.com/huri000/SwiftEntryKit", from: "2.0.0"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.5.2"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.0.0")
    ],
    
    targets: [
        .target(
            name: "LabelSwift",
            dependencies: [
                "Alamofire",
                "SwiftEntryKit",
                .product(name: "Lottie", package: "lottie-spm"),
                "Kingfisher"
            ],
            path: "Sources",
            resources: [
                .process("Resources/Media.xcassets")
            ]
        )
    ]

)
