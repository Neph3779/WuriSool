//
//  ProgramCell.swift
//  Brewery
//
//  Created by 천수현 on 2023/05/03.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import BreweryDomain
import Kingfisher

final class ProgramCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: ProgramCell.self)

    private let programImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.clipsToBounds = true
        return imageView
    }()

    private let programTitleLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .titleMedium)
        return label
    }()

    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        stackView.backgroundColor = DesignAsset.Colors.gray1.color
        return stackView
    }()

    private lazy var programInfoView: UIView = {
        let infoView = UIView()
        [programTitleLabel, infoStackView].forEach { infoView.addSubview($0) }
        programTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(20)
        }
        infoStackView.snp.makeConstraints {
            $0.top.equalTo(programTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        infoView.backgroundColor = .white
        infoView.layer.cornerRadius = 6
        infoView.clipsToBounds = true
        infoView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        infoView.layer.borderWidth = 1
        infoView.layer.borderColor = DesignAsset.Colors.gray1.color.cgColor
        return infoView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpContents(program: Program) {
        programImageView.kf.setImage(with: URL(string: program.imagePath))
        programTitleLabel.text = program.name
        [
            (DesignAsset.Images.note.image, program.description),
            (DesignAsset.Images.clock.image, program.time),
            (DesignAsset.Images.money.image, program.cost)
        ].forEach { (image, text) in
            let infoView = InfoView(image: image, description: text)
            infoStackView.addArrangedSubview(infoView)
        }
    }

    private func layout() {
        [programImageView, programInfoView].forEach { contentView.addSubview($0) }
        programImageView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(180)
        }
        programInfoView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(programImageView.snp.bottom)
        }
    }
}

fileprivate final class InfoView: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .bodySmall)
        label.textColor = DesignAsset.Colors.gray6.color
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()

    init(image: UIImage?, description: String) {
        super.init(frame: .zero)
        imageView.image = image
        descriptionLabel.text = description
        backgroundColor = .white
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        [imageView, descriptionLabel].forEach {
            addSubview($0)
        }
        imageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(13)
            $0.leading.equalToSuperview()
            $0.height.width.equalTo(20)
        }
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(16)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(13)
        }
    }
}
