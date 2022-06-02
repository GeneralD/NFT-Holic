// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NFT Holic",
	platforms: [
		.macOS(.v10_15),
	],
    dependencies: [
		.package(url: "https://github.com/GeneralD/CollectionKit", branch: "master"),
		.package(url: "https://github.com/JohnSundell/Files", from: "4.2.0"),
		.package(url: "https://github.com/jakeheis/SwiftCLI", from: "6.0.3"),
    ],
    targets: [
        .executableTarget(
            name: "NFT Holic",
			dependencies: ["CollectionKit", "Files", "SwiftCLI"]),
        .testTarget(
            name: "NFT HolicTests",
            dependencies: ["NFT Holic"]),
    ]
)
