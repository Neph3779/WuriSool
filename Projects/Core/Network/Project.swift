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

let project = Project.framework(
    name: projectName,
    product: .dynamicLibrary,
    platform: .iOS,
    iOSTargetVersion: iOSTargetVersion,
    dependencies: [
        .external(name: "FirebaseFirestore"),
        .external(name: "Alamofire")
    ],
    shouldIncludeTest: true
)
