//
//  Dependencies.swift
//  ProjectDescriptionHelpers
//
//  Created by 천수현 on 2023/04/01.
//

import ProjectDescription

let dependencies = Dependencies(
    carthage: [],
    swiftPackageManager: [
        .remote(url: "https://github.com/Alamofire/Alamofire", requirement: .upToNextMajor(from: "5.0.0")),
        .remote(url: "https://github.com/SnapKit/SnapKit", requirement: .upToNextMajor(from: "5.0.0")),
        .remote(url: "https://github.com/firebase/firebase-ios-sdk.git", requirement: .upToNextMajor(from: "10.4.0")),
        .remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .upToNextMajor(from: "7.0.0")),
        .remote(url: "https://github.com/ReactiveX/RxSwift.git", requirement: .upToNextMajor(from: "6.0.0")),
        .remote(url: "https://github.com/scalessec/Toast-Swift", requirement: .upToNextMajor(from: "5.0.0"))
    ],
    platforms: [.iOS]
)
