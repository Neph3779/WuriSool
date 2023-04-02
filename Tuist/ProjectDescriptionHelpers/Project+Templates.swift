import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    private static let organizationName = "com.neph"

    public static func app(name: String,
                           platform: Platform,
                           iOSTargetVersion: String,
                           infoPlist: [String: InfoPlist.Value],
                           dependencies: [TargetDependency] = []) -> Project {
        let targets = makeAppTargets(name: name,
                                     platform: platform,
                                     iOSTargetVersion: iOSTargetVersion,
                                     infoPlist: infoPlist,
                                     dependencies: dependencies)
        return Project(name: name,
                       organizationName: organizationName,
                       targets: targets)
    }

    public static func cleanArchitectureModule(name: String,
                                               platform: Platform = .iOS,
                                               iOSTargetVersion: String,
                                               infoPlist: [String: InfoPlist.Value] = [:],
                                               dependencies: [TargetDependency] = []) -> Project {

        let domainTargets = makeFrameworkTargets(name: "\(name)Domain", iOSTargetVersion: iOSTargetVersion)

        let presentationTargets = makeFrameworkTargets(
            name: "\(name)Presentation", iOSTargetVersion: iOSTargetVersion,
            dependencies: [
                .target(name: "\(name)Domain"),
                .external(name: "SnapKit")
            ]
        )

        let dataTargets = makeFrameworkTargets(
            name: "\(name)Data",
            iOSTargetVersion: iOSTargetVersion,
            dependencies: [
                .target(name: "\(name)Domain"),
                .project(target: "Network", path: .relativeToManifest("../Network"))
            ]
        )

        let moduleTargets = makeFrameworkTargets(
            name: name,
            iOSTargetVersion: iOSTargetVersion,
            dependencies: [
                .target(name: "\(name)Domain"),
                .target(name: "\(name)Data"),
                .target(name: "\(name)Presentation")
            ]
        )

        let demoAppTargets = makeAppTargets(
            name: "\(name)DemoApp",
            platform: platform,
            iOSTargetVersion: iOSTargetVersion,
            infoPlist: [
                "UILaunchStoryboardName": "LaunchScreen"
            ],
            dependencies: [
                .target(name: name)
            ]
        )

        let targets = [
            domainTargets,
            presentationTargets,
            dataTargets,
            moduleTargets,
            demoAppTargets
        ].reduce(into: []) { $0 += $1 }

        return Project(name: name,
                       organizationName: organizationName,
                       targets: targets)
    }

    public static func framework(name: String,
                                 platform: Platform, iOSTargetVersion: String,
                                 dependencies: [TargetDependency] = []) -> Project {
        let targets = makeFrameworkTargets(name: name,
                                           platform: platform,
                                           iOSTargetVersion: iOSTargetVersion,
                                           dependencies: dependencies)
        return Project(name: name,
                       organizationName: organizationName,
                       targets: targets)
    }
}

private extension Project {

    static func makeFrameworkTargets(name: String, platform: Platform = .iOS, iOSTargetVersion: String, dependencies: [TargetDependency] = []) -> [Target] {
        let sources = Target(name: name,
                             platform: platform,
                             product: .framework,
                             bundleId: "\(organizationName).\(name)",
                             deploymentTarget: .iOS(targetVersion: iOSTargetVersion, devices: [.iphone]),
                             infoPlist: .default,
                             sources: ["Sources/**"],
                             resources: ["Resources/**"],
                             dependencies: dependencies)
        let tests = Target(name: "\(name)Tests",
                           platform: platform,
                           product: .unitTests,
                           bundleId: "\(organizationName).\(name)Tests",
                           infoPlist: .default,
                           sources: ["Tests/**"],
                           resources: [],
                           dependencies: [
                            .target(name: name)
                           ])
        return [sources, tests]
    }

    static func makeAppTargets(name: String, platform: Platform, iOSTargetVersion: String, infoPlist: [String: InfoPlist.Value] = [:], dependencies: [TargetDependency] = []) -> [Target] {
        let platform: Platform = platform

        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: "\(organizationName).\(name)",
            deploymentTarget: .iOS(targetVersion: iOSTargetVersion, devices: [.iphone]),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: dependencies
        )

        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "\(organizationName).Tests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "\(name)")
            ])
        return [mainTarget, testTarget]
    }
}
