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

        let domainTargets = makeCleanArchitectureLayerTargets(
            name: "\(name)Domain",
            layer: .domain,
            iOSTargetVersion: iOSTargetVersion,
            dependencies: [
                .project(target: "BaseDomain", path: .relativeToRoot("Projects/Core/BaseDomain"))
            ]
        )

        let presentationTargets = makeCleanArchitectureLayerTargets(
            name: "\(name)Presentation",
            layer: .presentation,
            iOSTargetVersion: iOSTargetVersion,
            dependencies: [
                .target(name: "\(name)Domain"),
                .project(target: "Design", path: .relativeToRoot("Projects/Core/Design")),
                .external(name: "SnapKit"),
                .external(name: "Kingfisher"),
                .external(name: "RxSwift"),
                .external(name: "RxCocoa")
            ]
        )

        let dataTargets = makeCleanArchitectureLayerTargets(
            name: "\(name)Data",
            layer: .data,
            iOSTargetVersion: iOSTargetVersion,
            dependencies: [
                .target(name: "\(name)Domain"),
                .project(target: "Network", path: .relativeToRoot("Projects/Core/Network"))
            ]
        )

        let moduleTargets = makeFrameworkTargets(
            name: name,
            iOSTargetVersion: iOSTargetVersion,
            dependencies: [
                .target(name: "\(name)Domain"),
                .target(name: "\(name)Data"),
                .target(name: "\(name)Presentation")
            ],
            shouldIncludeTest: true
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
                                 product: Product = .staticFramework,
                                 platform: Platform, iOSTargetVersion: String,
                                 dependencies: [TargetDependency] = [],
                                 shouldIncludeTest: Bool) -> Project {
        let targets = makeFrameworkTargets(
            name: name,
            product: product,
            platform: platform,
            iOSTargetVersion: iOSTargetVersion,
            dependencies: dependencies,
            shouldIncludeTest: shouldIncludeTest
        )
        return Project(name: name,
                       organizationName: organizationName,
                       targets: targets)
    }
}

private extension Project {

    static func makeFrameworkTargets(name: String, product: Product = .staticFramework, platform: Platform = .iOS, iOSTargetVersion: String, dependencies: [TargetDependency] = [], shouldIncludeTest: Bool) -> [Target] {
        let sources = Target(name: name,
                             platform: platform,
                             product: .staticFramework,
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
        return shouldIncludeTest ? [sources, tests] : [sources]
    }

    static func makeCleanArchitectureLayerTargets(name: String, layer: Layer, platform: Platform = .iOS, iOSTargetVersion: String, dependencies: [TargetDependency] = []) -> [Target] {
        let sources = Target(name: name,
                             platform: platform,
                             product: .staticFramework,
                             bundleId: "\(organizationName).\(name)",
                             deploymentTarget: .iOS(targetVersion: iOSTargetVersion, devices: [.iphone]),
                             infoPlist: .default,
                             sources: ["Sources/\(layer.rawValue)/**"],
                             dependencies: dependencies)
        let tests = Target(name: "\(name)\(layer.rawValue)Tests",
                           platform: platform,
                           product: .unitTests,
                           bundleId: "\(organizationName).\(name)Tests",
                           infoPlist: .default,
                           sources: ["Tests/\(layer.rawValue)/**"],
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

private extension Project {
    enum Layer: String {
        case domain = "Domain"
        case presentation = "Presentation"
        case data = "Data"
    }
}
