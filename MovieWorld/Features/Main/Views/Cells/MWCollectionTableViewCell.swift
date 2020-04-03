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
    
    static let reuseId = "collectionViewTableViewCell"
    
    private let itemSize = CGSize(width: 130, height: 237)
    private let sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 7)
    
    var movies: [Movieable]?
    
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
                      forCellWithReuseIdentifier: MWMovieCardCollectionViewCell.reuseId)
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
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - constraints
    
    private func makeConstraints() {
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - functions
    
    private func addSubviews() {
        self.contentView.addSubview(self.collectionView)
        self.makeConstraints()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MWCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView
            .dequeueReusableCell(withReuseIdentifier: MWMovieCardCollectionViewCell.reuseId,
                                 for: indexPath)
            as? MWMovieCardCollectionViewCell ?? MWMovieCardCollectionViewCell()
        
        let movie = self.movies?[indexPath.row]
        cell.titleLabel.text = movie?.title
        cell.subtitleLabel.text = "\(movie?.releaseYear ?? ""), \(movie?.genres.first ?? "")"
        movie?.showImage(size: .w154, in: cell.imageView)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        (cell as? MWMovieCardCollectionViewCell)?.imageView.kf.cancelDownloadTask()
    }
}
