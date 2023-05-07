//
//  Coordinator.swift
//  BaseDomain
//
//  Created by 천수현 on 2023/05/07.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation

protocol Coordinator: AnyObject {
    associatedtype DIContainerProtocol: DIContainer
    var DIContainer: DIContainerProtocol { get }

    func start()
}
