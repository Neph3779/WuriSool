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

let project = Project(name: projectName, targets: [
    Target(
        name: projectName,
        platform: .iOS,
        product: .framework,
        bundleId: "com.neph.\(projectName)",
        deploymentTarget: .iOS(targetVersion: iOSTargetVersion, devices: [.iphone]),
        infoPlist: .default,
        resources: ["Resources/**"]
    )
])
