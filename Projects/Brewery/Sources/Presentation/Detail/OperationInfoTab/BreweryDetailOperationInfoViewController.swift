//
//  BreweryDetailOperationInfoViewController.swift
//  Brewery
//
//  Created by 천수현 on 2023/05/01.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import BreweryDomain
import Toast

final class BreweryDetailOperationInfoViewController: BreweryContainerViewController {

    private let disposeBag = DisposeBag()
    private let viewModel: BreweryDetailViewModel
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 1
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.backgroundColor = DesignAsset.Colors.gray1.color
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 0, left: 0, bottom: 1, right: 0)
        return stackView
    }()

    init(viewModel: BreweryDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
    }

    private func layout() {
        sizableView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview()
        }
    }

    private func bind() {
        viewModel.brewery
            .asDriver()
            .drive { [weak self] (brewery: Brewery) in
                guard let self = self else { return }
                [
                    (brewery.phoneNumber, DesignAsset.Images.phone.image),
                    (brewery.homePage, DesignAsset.Images.link.image),
                    (brewery.address, DesignAsset.Images.location.image)
                ].forEach { (text: String, image: UIImage) in
                    let infoView = InfoView(image: image, description: text, isCopyEnable: true)
                    self.stackView.addArrangedSubview(infoView)
                    infoView.copyButton.rx.tap
                        .asSignal()
                        .emit { [weak self] _ in
                            guard let self = self else { return }
                            self.view.makeToast("복사가 완료되었습니다.")
                        }
                        .disposed(by: self.disposeBag)
                }
            }
            .disposed(by: disposeBag)
    }
}
