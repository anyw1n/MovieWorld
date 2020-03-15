//
//  MWMovieListViewController.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/14/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWMovieListViewController: MWViewController {
    
    //MARK: - variables
    
    private let sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    private let collectionViewInsets = UIEdgeInsets(top: 16, left: 0, bottom: 26, right: 0)
    private let collectionViewHeight = 62
    var section: MWSection?
    
    //MARK: - gui variables
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 100, height: 26)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = self.sectionInsets
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect(),
                                    collectionViewLayout: self.collectionViewFlowLayout)
        view.dataSource = self
        view.delegate = self
        view.register(MWTagCollectionViewCell.self,
                      forCellWithReuseIdentifier: MWTagCollectionViewCell.reuseID)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        view.allowsMultipleSelection = true
        return view
    }()
    
    //MARK: - init
    
    override func initController() {
        super.initController()
        
        self.navigationItem.title = section?.name
        self.view.addSubview(self.collectionView)
        self.makeConstraints()
    }
    
    //MARK: - constraints
    
    private func makeConstraints() {
        self.collectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(self.collectionViewInsets)
            make.height.equalTo(self.collectionViewHeight)
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MWMovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MWS.sh.genres[.movie]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView
            .dequeueReusableCell(withReuseIdentifier: MWTagCollectionViewCell.reuseID,
                                 for: indexPath)
            as? MWTagCollectionViewCell ?? MWTagCollectionViewCell()
        cell.titleLabel.text = MWS.sh.genres[.movie]?[indexPath.row].name
        return cell
    }
}
