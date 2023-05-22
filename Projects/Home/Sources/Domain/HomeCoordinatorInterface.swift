//
//  HomeCoordinatorInterface.swift
//  HomeDomain
//
//  Created by 천수현 on 2023/05/07.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation

public protocol HomeCoordinatorInterface {
    func start()
    func liquorTapped(liquorName: String)
    func keywordTapped(keyword: Keyword)
    func recommendImageViewTapped()
}
