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
    
    // MARK: - variables
    
    private let insets = UIEdgeInsets(top: 24, left: 0, bottom: 15, right: 0)
    private let allButtonSize = CGSize(width: 52, height: 24)
    private let retryButtonSize = CGSize(width: 150, height: 40)
    var items: [T]?
    var maximumItems: Int = 10
    var sectionInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 7) {
        didSet {
            self.collectionViewFlowLayout.sectionInset = self.sectionInsets
        }
    }
    var allButtonTapped: (() -> Void)?
    var cellTapped: ((IndexPath) -> Void)?
    var retryButtonTapped: (() -> Void)?

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
        layout.minimumInteritemSpacing = 8
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
    
    private lazy var retryButton: UIButton = {
        let button = MWRoundedButton(text: "Retry".localized(),
                                     image: UIImage(named: "refreshIcon"))
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(self.retryButtonDidTap), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.headerView)
        self.addSubview(self.collectionView)
        self.addSubview(self.retryButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - constraints
    
    func makeConstraints() {
        self.headerView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(self.insets)
            make.left.equalToSuperview().inset(self.sectionInsets)
            make.right.lessThanOrEqualTo(self.allButton.snp.left).inset(16)
            make.bottom.lessThanOrEqualToSuperview()
        }
        self.allButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(self.insets)
            make.right.equalToSuperview().inset(self.sectionInsets)
            make.size.equalTo(self.allButtonSize)
        }
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(Cell.itemSize.height)
            make.bottom.equalToSuperview()
        }
        self.retryButton.snp.makeConstraints { (make) in
            make.center.equalTo(self.collectionView)
            make.size.equalTo(self.retryButtonSize)
        }
    }
    
    // MARK: - functions
    
    func setup(title: String,
               items: [T],
               itemSpacing: CGFloat,
               cellTapped: ((IndexPath) -> Void)? = nil,
               allButtonTapped: (() -> Void)? = nil,
               retryButtonTapped: (() -> Void)? = nil) {
        self.titleLabel.text = title
        self.items = items
        self.collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
        self.cellTapped = cellTapped
        if allButtonTapped == nil {
            self.allButton.isHidden = true
        } else {
            self.allButtonTapped = allButtonTapped
        }
        self.retryButtonTapped = retryButtonTapped
        
        if items.isEmpty {
            self.collectionView.isHidden = true
            self.retryButton.isHidden = false
        } else {
            self.collectionView.isHidden = false
            self.retryButton.isHidden = true
        }
        self.collectionView.reloadData()
    }
    
    @objc private func allButtonDidTap() {
        self.allButtonTapped?()
    }
    
    @objc private func retryButtonDidTap() {
        self.retryButtonTapped?()
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
            as? Cell ?? Cell()
        guard let item = self.items?[indexPath.row] else { return cell }
        
        cell.setup(item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.cellTapped?(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        (cell as? Cell)?.imageView.kf.cancelDownloadTask()
    }
}
