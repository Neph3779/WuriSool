//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 천수현 on 2023/04/01.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "Design"
private let iOSTargetVersion = "14.0"

let project = Project.framework(
    name: projectName,
    platform: .iOS,
    iOSTargetVersion: iOSTargetVersion,
    dependencies: [
        .external(name: "RxSwift"),
        .external(name: "RxCocoa")
    ],
    shouldIncludeTest: false,
    shouldIncludeResources: true
)
