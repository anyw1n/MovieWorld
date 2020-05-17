//
//  MWCollectionViewWithHeader.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/10/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWCollectionViewWithHeader<T, Cell: MWCollectionViewCell>:
UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - public stored

    var maximumItems: Int = 10

    var sectionInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 7) {
        didSet {
            self.collectionViewFlowLayout.sectionInset = self.sectionInsets
        }
    }

    weak var delegate: MWCollectionViewWithHeaderDelegate?

    // MARK: - private stored

    private let insets = UIEdgeInsets(top: 24, left: 0, bottom: 15, right: 0)
    private let allButtonSize = CGSize(width: 52, height: 24)

    private var items: [T]?

    // MARK: - gui variables

    private lazy var headerView: UIView = {
        let view = UIView()
        view.addSubview(self.titleLabel)
        view.addSubview(self.allButton)
        return view
    }()

    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor(named: "textColor")
        return label
    }()

    private lazy var allButton: MWRoundedButton = {
        let button = MWRoundedButton(text: "All".localized(), image: UIImage(named: "nextIcon"))
        button.addTarget(self, action: #selector(self.allButtonDidTap), for: .touchUpInside)
        return button
    }()

    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = Cell.itemSize
        layout.scrollDirection = .horizontal
        layout.sectionInset = self.sectionInsets
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect(),
                                    collectionViewLayout: self.collectionViewFlowLayout)
        view.dataSource = self
        view.delegate = self
        view.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseId)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        return view
    }()

    private lazy var retryView: MWRetryView = {
        let view = MWRetryView()
        view.delegate = self
        return view
    }()

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(self.headerView)
        self.addSubview(self.collectionView)
        self.addSubview(self.retryView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - constraints

    func makeConstraints() {
        self.headerView.snp.updateConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
        self.titleLabel.snp.updateConstraints { (make) in
            make.top.equalToSuperview().inset(self.insets)
            make.left.equalToSuperview().inset(self.sectionInsets)
            make.right.lessThanOrEqualTo(self.allButton.snp.left).inset(16)
            make.bottom.lessThanOrEqualToSuperview()
        }
        self.allButton.snp.updateConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(self.insets)
            make.right.equalToSuperview().inset(self.sectionInsets)
            make.size.equalTo(self.allButtonSize)
        }
        self.collectionView.snp.updateConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(Cell.itemSize.height)
            make.bottom.equalToSuperview()
        }
        self.retryView.snp.updateConstraints { (make) in
            make.edges.equalTo(self.collectionView)
        }
        self.retryView.makeConstraints()
    }

    // MARK: - setters

    func setup(title: String,
               items: [T],
               itemSpacing: CGFloat = 8,
               allButtonEnabled: Bool = true,
               retryButtonEnabled: Bool = true) {
        self.titleLabel.text = title
        self.items = items
        self.collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing

        if items.isEmpty {
            self.retryView.show(retryButtonEnabled: retryButtonEnabled)
            self.allButton.isHidden = true
        } else {
            self.retryView.hide()
            self.allButton.isHidden = !allButtonEnabled
        }

        self.collectionView.reloadData()
    }

    // MARK: - actions

    @objc private func allButtonDidTap() {
        self.delegate?.allButtonTapped()
    }

    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let items = self.items else { return 0 }
        return items.count >= self.maximumItems ? self.maximumItems : items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: Cell.reuseId,
                                 for: indexPath)

        guard let item = self.items?[indexPath.row] else { return cell }

        (cell as? Cell)?.setup(item)
        cell.setNeedsUpdateConstraints()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.cellTapped(indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        (cell as? Cell)?.imageView.kf.cancelDownloadTask()
    }
}

// MARK: - MWRetryViewDelegate

extension MWCollectionViewWithHeader: MWRetryViewDelegate {

    func retryButtonTapped() {
        self.delegate?.retryButtonTapped()
    }

    func message() -> String? {
        self.delegate?.message()
    }
}

// MARK: - MWCollectionViewWithHeaderDelegate

protocol MWCollectionViewWithHeaderDelegate: AnyObject {

    func cellTapped(indexPath: IndexPath)
    func retryButtonTapped()
    func message() -> String?
    func allButtonTapped()
}

extension MWCollectionViewWithHeaderDelegate {

    func cellTapped(indexPath: IndexPath) { }
    func retryButtonTapped() { }
    func message() -> String? {
        return "Oops, something went wrong(".localized()
    }
    func allButtonTapped() { }
}
