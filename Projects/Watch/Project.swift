//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 천수현 on 2023/04/01.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "Watch"
private let iOSTargetVersion = "15.0"

let project = Project.cleanArchitectureModule(name: projectName, iOSTargetVersion: iOSTargetVersion)
