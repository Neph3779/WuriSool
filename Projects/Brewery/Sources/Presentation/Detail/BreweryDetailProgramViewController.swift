//
//  BreweryDetailProgramViewController.swift
//  Brewery
//
//  Created by 천수현 on 2023/05/01.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit

final class BreweryDetailProgramViewController: BreweryContainerViewController {

    private let someView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        someView.backgroundColor = .red
        sizableView.addSubview(someView)
        someView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(500)
        }
    }
}
