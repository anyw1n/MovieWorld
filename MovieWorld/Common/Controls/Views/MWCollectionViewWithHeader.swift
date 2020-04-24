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
    private let buttonSize = CGSize(width: 52, height: 24)
    var items: [T]?
    var maximumItems: Int = 10
    var sectionInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 7) {
        didSet {
            self.collectionViewFlowLayout.sectionInset = self.sectionInsets
        }
    }
    var allButtonTapped: (() -> Void)?
    var cellTapped: ((IndexPath) -> Void)?

    // MARK: - gui variables
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.addSubview(self.titleLabel)
        view.addSubview(self.button)
        return view
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    private lazy var button: MWRoundedButton = {
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
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.headerView)
        self.addSubview(self.collectionView)
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
            make.right.lessThanOrEqualTo(self.button.snp.left).inset(16)
            make.bottom.lessThanOrEqualToSuperview()
        }
        self.button.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(self.insets)
            make.right.equalToSuperview().inset(self.sectionInsets)
            make.size.equalTo(self.buttonSize)
        }
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(Cell.itemSize.height)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - functions
    
    func setup(title: String,
               items: [T],
               itemSpacing: CGFloat,
               cellTapped: ((IndexPath) -> Void)? = nil,
               allButtonTapped: (() -> Void)? = nil) {
        self.titleLabel.text = title
        self.items = items
        self.collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
        self.cellTapped = cellTapped
        if allButtonTapped == nil {
            self.button.isHidden = true
        } else {
            self.allButtonTapped = allButtonTapped
        }
        self.collectionView.reloadData()
    }
    
    @objc private func allButtonDidTap() {
        self.allButtonTapped?()
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
