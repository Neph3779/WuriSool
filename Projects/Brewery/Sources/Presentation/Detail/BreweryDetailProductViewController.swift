//
//  BreweryDetailProductViewController.swift
//  Brewery
//
//  Created by 천수현 on 2023/05/01.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class BreweryDetailProductViewController: BreweryContainerViewController {
    private let someView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        someView.backgroundColor = .brown
        sizableView.addSubview(someView)
        someView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(1000)
        }
    }
}
