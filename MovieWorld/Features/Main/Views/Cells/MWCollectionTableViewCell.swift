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
    
    // MARK: - gui variables
    
    private(set) lazy var collectionView: MWCollectionViewWithHeader<Movieable,
        MWMovieCardCollectionViewCell> = {
            let view = MWCollectionViewWithHeader<Movieable, MWMovieCardCollectionViewCell>()
            view.titleLabel.font = .boldSystemFont(ofSize: 24)
            view.sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 7)
            view.maximumItems = 20
            return view
    }()
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .white
        self.selectionStyle = .none
        self.contentView.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.collectionView.makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
