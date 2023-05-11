//
//  VideoCell.swift
//  Watch
//
//  Created by 천수현 on 2023/05/03.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import WatchDomain
import Kingfisher

final class VideoCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: VideoCell.self)
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
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
        label.applyFont(font: .buttonMedium)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        return label
    }()
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
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

    func setUpContents(video: YoutubeVideo, channel: LiquorChannel) {
        guard let video = video.items.first else { return }
        thumbnailImageView.kf.setImage(with: URL(string: video.snippet.thumbnails.high.url))
        titleLabel.text = video.snippet.title
        profileImageView.image = channel.profileImage
        channelNameLabel.text = video.snippet.channelTitle
        titleLabel.lineBreakMode = .byTruncatingTail
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
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(8)
        }
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(5)
        }
        channelNameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
            $0.centerY.equalTo(profileImageView)
            $0.trailing.equalToSuperview()
        }
    }
}
