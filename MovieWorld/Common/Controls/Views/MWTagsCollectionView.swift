//
//  MWTagsCollectionView.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/24/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWTagsCollectionView: UIView {
    
    // MARK: - variables
    
    static let height: CGFloat = 92
    private let collectionViewInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    private var section: MWSection?
    private var tagTapped: (() -> Void)?
    
    // MARK: - gui variables
    
    private lazy var tagCollectionViewLayout: MWTagCollectionViewLayout = {
        let layout = MWTagCollectionViewLayout()
        layout.delegate = self
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect(),
                                    collectionViewLayout: self.tagCollectionViewLayout)
        view.dataSource = self
        view.delegate = self
        view.register(MWTagCollectionViewCell.self,
                      forCellWithReuseIdentifier: MWTagCollectionViewCell.reuseId)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        view.allowsMultipleSelection = true
        view.contentInset = self.collectionViewInsets
        return view
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - functions
    
    func setup(section: MWSection, tagTapped: (() -> Void)? = nil) {
        self.section = section
        self.tagTapped = tagTapped
        self.collectionView.reloadData()
    }
}

// MARK: - MWTagCollectionViewLayoutDelegate

extension MWTagsCollectionView: MWTagCollectionViewLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, widthForTagAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard let genre = self.section?.category == nil
            ? MWS.sh.allGenres[indexPath.row]
            : MWS.sh.genres[self.section!.category!]?[indexPath.row] else { return 0 }
        
        let genreName = genre.name as NSString? ?? ""
        let genreNameWidth =
            genreName.size(withAttributes: [.font: UIFont.systemFont(ofSize: 13)]).width
        let inset: CGFloat = 12
        return genreNameWidth + inset * 2
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MWTagsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let category = self.section?.category {
            return MWS.sh.genres[category]?.count ?? 0
        } else {
            return MWS.sh.allGenres.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView
            .dequeueReusableCell(withReuseIdentifier: MWTagCollectionViewCell.reuseId,
                                 for: indexPath)
            as? MWTagCollectionViewCell ?? MWTagCollectionViewCell()
        guard let genre = self.section?.category == nil
            ? MWS.sh.allGenres[indexPath.row]
            : MWS.sh.genres[self.section!.category!]?[indexPath.row] else { return cell }
        
        cell.button.setTitle(genre.name, for: .init())
        if self.section?.genreIds?.contains(genre.id) ?? false {
            cell.isSelected = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let genre = self.section?.category == nil
            ? MWS.sh.allGenres[indexPath.row]
            : MWS.sh.genres[self.section!.category!]?[indexPath.row] else { return }
        
        if self.section?.genreIds != nil {
            self.section?.genreIds!.insert(genre.id)
        } else {
            self.section?.genreIds = [genre.id]
        }
        self.tagTapped?()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let genre = self.section?.category == nil
            ? MWS.sh.allGenres[indexPath.row]
            : MWS.sh.genres[self.section!.category!]?[indexPath.row] else { return }
        
        self.section?.genreIds?.remove(genre.id)
        self.tagTapped?()
    }
}
