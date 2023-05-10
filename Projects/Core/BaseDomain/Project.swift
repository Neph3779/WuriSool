//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 천수현 on 2023/04/19.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "BaseDomain"
private let iOSTargetVersion = "14.0"

let project = Project.framework(
    name: projectName,
    product: .dynamicLibrary,
    platform: .iOS,
    iOSTargetVersion: iOSTargetVersion,
    shouldIncludeTest: true,
    shouldIncludeResources: false
)
