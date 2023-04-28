//
//  BreweryListViewController.swift
//  App
//
//  Created by 천수현 on 2023/04/02.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit

final class BreweryListViewController: UIViewController {

    private let viewModel: BreweryListViewModel

    init(viewModel: BreweryListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
