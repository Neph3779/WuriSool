//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 천수현 on 2023/05/10.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "AppCoordinator"
private let iOSTargetVersion = "14.0"

let project = Project.framework(name: projectName, platform: .iOS, iOSTargetVersion: iOSTargetVersion, shouldIncludeTest: false, shouldIncludeResources: false)
