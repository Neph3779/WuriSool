//
//  BreweryDetailOperationInfoViewController.swift
//  Brewery
//
//  Created by 천수현 on 2023/05/01.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit

final class BreweryDetailOperationInfoViewController: BreweryContainerViewController {
    private let viewModel: BreweryDetailViewModel
    private let someView = UIView()

    init(viewModel: BreweryDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        someView.backgroundColor = .blue
        sizableView.addSubview(someView)
        someView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(3000)
        }
    }
}
