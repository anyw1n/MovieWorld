//
//  MWFilmographyView.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/23/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWFilmographyView: UIView {

    // MARK: - variables
    
    private let sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 26)
    private let collectionViewItemSize = CGSize(width: 130, height: 237)
    private let collectionViewHeaderButtonSize = CGSize(width: 52, height: 24)
    var movies: [Movieable]?
    
    // MARK: - gui variables
    
    private lazy var collectionViewHeader: UIView = {
        let view = UIView()
        view.addSubview(self.collectionViewHeaderTitleLabel)
        view.addSubview(self.collectionViewHeaderButton)
        return view
    }()
    
    private lazy var collectionViewHeaderTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Filmography".localized()
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
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = self.sectionInset
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.collectionViewHeader)
        self.addSubview(self.collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - constraints
    
    func makeConstraints() {
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
    
    func setup(actor: MWActor) {
        guard let movies = actor.details?.movieCredits?.cast,
            let tv = actor.details?.tvCredits?.cast else { return }
        self.movies = movies + tv
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MWFilmographyView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let movies = self.movies else { return 0 }
        return movies.count >= 10 ? 10 : movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: MWMovieCardCollectionViewCell.reuseId,
                                 for: indexPath)
            as? MWMovieCardCollectionViewCell ?? MWMovieCardCollectionViewCell()
        guard let movie = self.movies?[indexPath.row] else { return cell }
        
        cell.setup(movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = self.movies?[indexPath.row] else { return }
        let controller = MWMovieDetailsViewController()
        controller.movie = movie
        MWI.sh.push(controller)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        (cell as? MWMovieCardCollectionViewCell)?.imageView.kf.cancelDownloadTask()
    }
}
