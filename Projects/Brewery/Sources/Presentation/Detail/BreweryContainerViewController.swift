//
//  BreweryContainerViewController.swift
//  Brewery
//
//  Created by 천수현 on 2023/05/02.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BreweryContainerViewController: UIViewController {
    var sizableView = SizableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sizableView)
        sizableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
