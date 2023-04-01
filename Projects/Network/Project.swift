//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 천수현 on 2023/04/01.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "Network"
private let iOSTargetVersion = "14.0"

let project = Project.frameworkWithDemoApp(
    name: projectName,
    platform: .iOS,
    iOSTargetVersion: iOSTargetVersion,
    infoPlist: [:],
    dependencies: [
        .external(name: "Alamofire")
    ]
)
