//
//  LiquorCoordinatorInterface.swift
//  Liquor
//
//  Created by 천수현 on 2023/05/07.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation
import BaseDomain

public protocol LiquorCoordinatorInterface: Coordinator {
    func liquorItemSelected(itemName: String)
}
