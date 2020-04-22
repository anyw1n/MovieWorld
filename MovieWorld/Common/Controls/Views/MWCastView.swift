//
//  MWCastView.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/10/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWCastView: UIView {

    // MARK: - variables
    
    private let sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 26)
    private let collectionViewItemSize = CGSize(width: 72, height: 124)
    private let collectionViewHeaderButtonSize = CGSize(width: 52, height: 24)
    var cast: [MWActor]?
    
    // MARK: - gui variables
    
    private lazy var collectionViewHeader: UIView = {
        let view = UIView()
        view.addSubview(self.collectionViewHeaderTitleLabel)
        view.addSubview(self.collectionViewHeaderButton)
        return view
    }()
    
    private lazy var collectionViewHeaderTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cast".localized()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    private(set) lazy var collectionViewHeaderButton: MWRoundedButton =
        MWRoundedButton(text: "All".localized(), image: UIImage(named: "nextIcon"))
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.collectionViewItemSize
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = self.sectionInset
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect(),
                                    collectionViewLayout: self.collectionViewFlowLayout)
        view.dataSource = self
        view.delegate = self
        view.register(MWActorCollectionViewCell.self,
                      forCellWithReuseIdentifier: MWActorCollectionViewCell.reuseId)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.collectionViewHeader)
        self.addSubview(self.collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - constraints
    
    func makeInternalConstraints() {
        self.collectionViewHeader.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(self.sectionInset)
        }
        self.collectionViewHeaderTitleLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.right.lessThanOrEqualTo(self.collectionViewHeaderButton).inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
        self.collectionViewHeaderButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.size.equalTo(self.collectionViewHeaderButtonSize)
        }
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.collectionViewHeader.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(self.collectionViewItemSize.height)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - functions
    
    func setup(cast: [MWActor]) {
        self.cast = cast
        self.collectionView.reloadData()
    }
}

extension MWCastView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let cast = self.cast else { return 0 }
        return cast.count >= 10 ? 10 : cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: MWActorCollectionViewCell.reuseId,
                                 for: indexPath)
            as? MWActorCollectionViewCell ?? MWActorCollectionViewCell()
        guard let actor = self.cast?[indexPath.row] else { return cell }
        
        cell.setup(actor: actor)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        (cell as? MWActorCollectionViewCell)?.imageView.kf.cancelDownloadTask()
    }
}
