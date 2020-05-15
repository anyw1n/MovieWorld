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

    var items: [Mediable]?
    var viewController: UIViewController

    private let messageInsets = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
    private let contentInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

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

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "textColor")
        label.text = "Nothing to show here..".localized()
        label.alpha = 0.5
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    // MARK: - init

    init(in viewController: UIViewController) {
        self.viewController = viewController
        super.init(frame: CGRect())

        self.addSubview(self.collectionViewTitleLabel)
        self.addSubview(self.collectionView)
        self.addSubview(self.messageLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - constraints

    func makeConstraints() {
        self.collectionViewTitleLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().inset(self.contentInsets)
            make.right.lessThanOrEqualToSuperview().inset(self.contentInsets)
        }
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.collectionViewTitleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(MWMediaCollectionViewCell.itemSize.height)
            make.bottom.equalToSuperview()
        }
        self.messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.collectionView.snp.top).inset(self.messageInsets)
            make.left.greaterThanOrEqualToSuperview().inset(self.messageInsets)
            make.right.lessThanOrEqualToSuperview().inset(self.messageInsets)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }

    // MARK: - functions

    func setup(items: [Mediable]) {
        if !items.isEmpty {
            self.messageLabel.isHidden = true
            self.items = items
            self.collectionView.reloadData()
        } else {
            self.messageLabel.isHidden = false
        }
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

        guard let item = self.items?[indexPath.row] else { return cell }

        (cell as? MWMediaCollectionViewCell)?.setup(item)
        cell.setNeedsUpdateConstraints()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        (cell as? MWMediaCollectionViewCell)?.imageView.kf.cancelDownloadTask()
        (cell as? MWMediaCollectionViewCell)?.playerView.thumbnail.kf.cancelDownloadTask()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = self.items?[indexPath.row] else { return MWMediaCollectionViewCell.itemSize }
        var size = MWMediaCollectionViewCell.itemSize
        if let item = item as? MWMovieImage {
            size.width = item.calculateWidth(height: size.height)
        }
        return size
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let image = self.items?[indexPath.row] as? MWMovieImage else { return }
        let controller = MWFullscreenImageViewController()
        controller.setup(TMDBPath: image.filePath)
        self.viewController.present(controller, animated: true)
    }
}
