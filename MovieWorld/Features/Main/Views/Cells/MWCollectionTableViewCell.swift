//
//  MWTableViewCell.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/1/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWCollectionTableViewCell: UITableViewCell {

    // MARK: - variables

    static let reuseID = "MWCollectionTableViewCell"

    var movies: [MWMovie]?

    private let itemSize = CGSize(width: 130, height: 237)
    private let sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 7)

    // MARK: - gui variables

    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.itemSize
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = self.sectionInsets
        return layout
    }()

    private(set) lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect(),
                                    collectionViewLayout: self.collectionViewFlowLayout)
        view.dataSource = self
        view.delegate = self
        view.register(MWMovieCardCollectionViewCell.self,
                      forCellWithReuseIdentifier: MWMovieCardCollectionViewCell.reuseID)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        return view
    }()

    // MARK: - init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .white
        self.selectionStyle = .none
        self.contentView.addSubview(self.collectionView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - constraints

    override func updateConstraints() {
        self.collectionView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        super.updateConstraints()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MWCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: MWMovieCardCollectionViewCell.reuseID,
                                 for: indexPath)
        guard let cardCell = cell as? MWMovieCardCollectionViewCell else { return cell }

        let movie = self.movies?[indexPath.row]
        cardCell.titleLabel.text = movie?.title
        cardCell.subtitleLabel.text = "\(movie?.releaseYear ?? ""), \(movie?.genres.first ?? "")"
        movie?.showImage(size: .w154, in: cardCell.imageView)
        cardCell.setNeedsUpdateConstraints()
        return cardCell
    }

    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        (cell as? MWMovieCardCollectionViewCell)?.imageView.kf.cancelDownloadTask()
    }
}
