//
//  CardNewsCell.swift
//  HomeDomain
//
//  Created by 천수현 on 2023/04/06.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

final class CardNewsCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: CardNewsCell.self)
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpImage(imagePath: String) {
        imageView.kf.setImage(with: URL(string: imagePath))
    }

    private func layout() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
