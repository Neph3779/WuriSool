//
//  VideoCell.swift
//  Watch
//
//  Created by 천수현 on 2023/05/03.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit

final class VideoCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: VideoCell.self)
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        let youtubeImageView = UIImageView()
        youtubeImageView.image = DesignAsset.Images.youtube.image
        imageView.addSubview(youtubeImageView)
        youtubeImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .bodySmall)
        return label
    }()
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private let channelNameLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .captionLarge)
        label.textColor = DesignAsset.Colors.gray5.color
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpContents() {

    }

    private func layout() {
        [thumbnailImageView, titleLabel, profileImageView, channelNameLabel].forEach {
            contentView.addSubview($0)
        }
        thumbnailImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(190)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(4)
        }
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview()
        }
        channelNameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(4)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.trailing.equalToSuperview()
        }
    }
}
