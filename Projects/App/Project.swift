//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 천수현 on 2023/04/01.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "App"
private let iOSTargetVersion = "14.0"

let project = Project.app(
    name: projectName,
    platform: .iOS,
    iOSTargetVersion: iOSTargetVersion,
    infoPlist: [
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1",
        "UIMainStoryboardFile": "",
        "UILaunchStoryboardName": "LaunchScreen"
        ],
    dependencies: [
        .project(target: "Home", path: .relativeToCurrentFile("../Home")),
        .project(target: "Brewery", path: .relativeToCurrentFile("../Brewery")),
        .project(target: "Liquor", path: .relativeToCurrentFile("../Liquor")),
        .project(target: "Watch", path: .relativeToCurrentFile("../Watch"))
    ]
)