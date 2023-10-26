//
//  Package.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 25/10/23.
//

import PackageDescription

let package = Package(
    name: "LBTasks-iOS",
    products: [
        .library(name: "LBTasks-iOS", targets: ["LBTasks-iOS"]),
    ],
    targets: [
        .target(name: "LBTasks-iOS", dependencies: []),
        .testTarget(name: "LBTasks-iOSTests", dependencies: ["LBTasks-iOS"]),
    ]
)
