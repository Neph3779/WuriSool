//
//  BreweryDetailProgramViewController.swift
//  Brewery
//
//  Created by 천수현 on 2023/05/01.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import BreweryDomain
import RxSwift
import RxCocoa

final class BreweryDetailProgramViewController: BreweryContainerViewController {

    private let disposeBag = DisposeBag()
    private let viewModel: BreweryDetailViewModel

    private let outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.backgroundColor = DesignAsset.Colors.gray1.color
        return stackView
    }()
    
    private lazy var programCollectionView = SizableCollectionView(frame: .zero,
                                                                   collectionViewLayout: programCollectionViewLayout())
    private lazy var programDataSource = makeProgramDataSource()

    

    init(viewModel: BreweryDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpProgramCollectionView()
        layout()
        bind()
    }

    private func setUpProgramCollectionView() {
        programCollectionView.register(ProgramCell.self, forCellWithReuseIdentifier: ProgramCell.reuseIdentifier)
        programCollectionView.isScrollEnabled = false
    }

    private func layout() {
        sizableView.addSubview(outerStackView)
        outerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        outerStackView.addArrangedSubview(programCollectionView)
        programCollectionView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(1)
        }
    }

    private func bind() {
        viewModel.brewery
            .asDriver()
            .drive { [weak self] (brewery: Brewery) in
                self?.applyDataSource(programs: brewery.programs)
            }
            .disposed(by: disposeBag)

        programCollectionView.contentSizeDidChanged
            .asSignal()
            .emit { [weak self] size in
                if size.height > 0 {
                    self?.programCollectionView.snp.remakeConstraints {
                        $0.height.equalTo(size.height)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - CollectionView Layout

extension BreweryDetailProgramViewController {
    private func programCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .estimated(380)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                       heightDimension: .estimated(380)),
                                                     subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 16, bottom: 20, trailing: 16)
        section.interGroupSpacing = 20
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - CollectionView DataSource

extension BreweryDetailProgramViewController {
    enum ProgramSection {
        case main
    }

    private func makeProgramDataSource() -> UICollectionViewDiffableDataSource<ProgramSection, Program> {
        return .init(collectionView: programCollectionView) { collectionView, indexPath, program in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgramCell.reuseIdentifier, for: indexPath) as? ProgramCell else { return UICollectionViewCell() }
            cell.setUpContents(program: program)
            return cell
        }
    }

    private func applyDataSource(programs: [Program]) {
        var programSnapShot = NSDiffableDataSourceSnapshot<ProgramSection, Program>()
        programSnapShot.deleteAllItems()
        programSnapShot.appendSections([.main])
        programSnapShot.appendItems(programs)
        programDataSource.apply(programSnapShot)
    }
}
