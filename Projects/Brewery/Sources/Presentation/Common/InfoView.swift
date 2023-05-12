//
//  InfoView.swift
//  Brewery
//
//  Created by 천수현 on 2023/05/03.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import Kingfisher

final class InfoView: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .bodySmall)
        label.textColor = DesignAsset.Colors.gray6.color
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.lineBreakStrategy = .hangulWordPriority
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(descriptionLabelTapped(_:))))
        return label
    }()
    lazy var copyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        button.tintColor = .black
        button.addAction(UIAction { [weak self] _ in
            UIPasteboard.general.string = self?.descriptionLabel.text
        }, for: .touchUpInside)
        return button
    }()

    init(image: UIImage?, description: String, isCopyEnable: Bool = false) {
        super.init(frame: .zero)
        backgroundColor = .white
        imageView.image = image
        descriptionLabel.text = description
        layout()
        copyButton.isHidden = !isCopyEnable
        setLinkMoves()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLinkMoves() {
        guard let description = descriptionLabel.text else { return }
        if !description.isEmpty,
           let url = URL(string: "tel://\(description)"),
           UIApplication.shared.canOpenURL(url) {
            descriptionLabel.underline = .single
        } else if let url = URL(string: description),
                  UIApplication.shared.canOpenURL(url) {
            descriptionLabel.underline = .single
        }
    }

    private func layout() {
        [imageView, descriptionLabel, copyButton].forEach {
            addSubview($0)
        }
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.width.equalTo(16)
        }
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(16)
            $0.top.bottom.equalToSuperview().inset(15)
            $0.trailing.equalToSuperview().inset(13).priority(.low)
            $0.trailing.equalTo(copyButton.snp.leading).priority(.high)
        }
        copyButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(15)
            $0.height.width.equalTo(16)
        }
    }

    @objc
    private func descriptionLabelTapped(_ sender: UIGestureRecognizer) {
        guard let description = descriptionLabel.text else { return }
        let phoneNumber = description.filter { $0.isWholeNumber }
        if !phoneNumber.isEmpty,
           let url = URL(string: "tel://\(phoneNumber)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            descriptionLabel.underline = .single
        } else if let url = URL(string: description),
                  UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            descriptionLabel.underline = .single
        }
    }
}
