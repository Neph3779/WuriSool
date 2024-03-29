//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 천수현 on 2023/05/10.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "AppCoordinator"
private let iOSTargetVersion = "15.0"

let project = Project.framework(
    name: projectName,
    platform: .iOS,
    iOSTargetVersion: iOSTargetVersion,
    dependencies: [
        .project(target: "BaseDomain", path: .relativeToRoot("Projects/Core/BaseDomain"))
    ],
    shouldIncludeTest: false,
    shouldIncludeResources: false
)
