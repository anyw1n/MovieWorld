//
//  MWGalleryView.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/12/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWGalleryView: UIView {
    
    // MARK: - variables
    
    private let collectionViewItemSize = CGSize(width: 180, height: 87)
    private let contentInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    var viewForFullscreen: UIView? {
        didSet {
            guard let view = self.viewForFullscreen else { return }
            view.addSubview(self.fullscreenImageView)
            self.fullscreenImageView.snp.makeConstraints { (make) in
                make.edges.equalTo(view)
            }
        }
    }
    var items: [Mediable]?
    
    // MARK: - gui variables
    
    private lazy var collectionViewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Trailers and gallery".localized()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = self.contentInsets
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect(),
                                    collectionViewLayout: self.collectionViewFlowLayout)
        view.dataSource = self
        view.delegate = self
        view.register(MWMediaCollectionViewCell.self,
                      forCellWithReuseIdentifier: MWMediaCollectionViewCell.reuseId)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var fullscreenImageView: UIImageView = {
        let view = UIImageView()
        view.isHidden = true
        view.alpha = 0
        view.contentMode = .scaleAspectFit
        view.backgroundColor = UIColor(named: "textColor")?.withAlphaComponent(0.8)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(self.disableFullscreen)))
        return view
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.collectionViewTitleLabel)
        self.addSubview(self.collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - constraints
    
    func makeInternalConstraints() {
        self.collectionViewTitleLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().inset(self.contentInsets)
            make.right.lessThanOrEqualToSuperview().inset(self.contentInsets)
        }
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.collectionViewTitleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(self.collectionViewItemSize.height)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - functions
    
    func setup(items: [Mediable]) {
        self.items = items
        self.collectionView.reloadData()
    }
    
    @objc private func disableFullscreen() {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.fullscreenImageView.alpha = 0
        }, completion: { (_) in
            self.fullscreenImageView.isHidden = true
            self.fullscreenImageView.image = nil
        })
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension MWGalleryView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MWMediaCollectionViewCell.reuseId, for: indexPath)
            as? MWMediaCollectionViewCell ?? MWMediaCollectionViewCell()
        guard let item = self.items?[indexPath.row] else { return cell }
        
        cell.setup(item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        (cell as? MWMediaCollectionViewCell)?.imageView.kf.cancelDownloadTask()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = self.items?[indexPath.row] else { return self.collectionViewItemSize }
        var size = self.collectionViewItemSize
        if let item = item as? MWMovieImage {
            size.width = item.calculateWidth(height: size.height)
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.items?[indexPath.row] as? MWMovieImage,
            let viewForFullscreen = self.viewForFullscreen else { return }
        
        viewForFullscreen.bringSubviewToFront(self.fullscreenImageView)
        item.showImage(size: .w1280, in: self.fullscreenImageView)
        self.fullscreenImageView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.fullscreenImageView.alpha = 1
        }
    }
}
