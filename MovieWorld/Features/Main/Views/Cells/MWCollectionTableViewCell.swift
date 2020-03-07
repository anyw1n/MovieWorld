//
//  MWTableViewCell.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/1/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWCollectionTableViewCell: UITableViewCell {
    
    static let reuseID = "collectionViewTableViewCell"
    
    var movies: [MWMovie]?
    
    private let itemSize = CGSize(width: 130, height: 237)
    private let sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    
    lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.itemSize
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = self.sectionInsets
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect(),
                                    collectionViewLayout: self.collectionViewFlowLayout)
        view.dataSource = self
        view.delegate = self
        view.register(MWCollectionViewCell.self,
                      forCellWithReuseIdentifier: MWCollectionViewCell.reuseID)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        return view
    }()
    
    private func addSubviews() {
        self.contentView.addSubview(self.collectionView)
        self.makeConstraints()
    }
    
    private func makeConstraints() {
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .white
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MWCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView
            .dequeueReusableCell(withReuseIdentifier: MWCollectionViewCell.reuseID,
                                 for: indexPath)
            as? MWCollectionViewCell ?? MWCollectionViewCell()
        let movie = self.movies?[indexPath.row]
        
        cell.imageView.image = movie?.image
        cell.titleLabel.text = movie?.title
        cell.subtitleLabel.text = "\(movie?.releaseYear ?? ""), \(movie?.genres.first ?? "")"
        return cell
    }
    
}
