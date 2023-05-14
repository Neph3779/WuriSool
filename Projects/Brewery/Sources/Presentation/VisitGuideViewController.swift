//
//  VisitGuideViewController.swift
//  Brewery
//
//  Created by 천수현 on 2023/05/15.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import Kingfisher

final class VisitGuideViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    init(breweryId: Int) {
        super.init(nibName: nil, bundle: nil)
        imageView.kf.setImage(with: URL(string: "https://raw.githubusercontent.com/Neph3779/Blog-Image/master/WuriSoolGuideBook/\(breweryId).png"))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 250/250, green: 243/250, blue: 228/250, alpha: 1)
        layout()

        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false

        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        scrollView.delegate = self

        setUpNavigationBar()

    }

    private func setUpNavigationBar() {
        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.configureWithTransparentBackground()
        scrollEdgeAppearance.backgroundColor = UIColor(red: 250/250, green: 243/250, blue: 228/250, alpha: 1)
        scrollEdgeAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.title = "방문 가이드"
    }

    private func layout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        scrollView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.width.equalTo(view)
            $0.height.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension VisitGuideViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.zoomScale <= 1.0 {
            scrollView.zoomScale = 1.0
        }

        if scrollView.zoomScale >= 2.0 {
            scrollView.zoomScale = 2.0
        }
    }
}
