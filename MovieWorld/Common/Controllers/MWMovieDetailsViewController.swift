//
//  MWMovieDetailsViewController.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/4/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWMovieDetailsViewController: MWViewController {
    
    // MARK: - variables
    
    private let contentInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    private let castCollectionViewItemSize = CGSize(width: 72, height: 124)
    private let castCollectionViewHeaderButtonSize = CGSize(width: 52, height: 24)
    private let dispatchGroup = DispatchGroup()
    var movie: Movieable? {
        didSet {
            self.dispatchGroup.enter()
            self.movie?.requestDetails([.credits, .images, .videos]) { [weak self] in
                self?.dispatchGroup.leave()
            }
        }
    }
    
    // MARK: - gui variables
    
    private let movieCardView: MWMovieCardView = MWMovieCardView()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.addSubview(self.movieCardView)
        view.addSubview(self.moviePlayer)
        view.addSubview(self.descriptionView)
        view.addSubview(self.castView)
        return view
    }()
    
    private lazy var moviePlayer: UIView = UIView()
    
    private lazy var descriptionView: UIView = {
        let view = UIView()
        view.addSubview(self.descriptionTitleLabel)
        view.addSubview(self.descriptionSubtitleLabel)
        view.addSubview(self.descriptionTextLabel)
        return view
    }()
    
    private lazy var descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Description".localized()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    private lazy var descriptionSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "textColor")
        label.alpha = 0.5
        return label
    }()
    
    private lazy var descriptionTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor(named: "textColor")
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var castView: UIView = {
        let view = UIView()
        view.addSubview(self.castCollectionViewHeader)
        view.addSubview(self.castCollectionView)
        return view
    }()
    
    private lazy var castCollectionViewHeader: UIView = {
        let view = UIView()
        view.addSubview(self.castCollectionViewHeaderTitleLabel)
        view.addSubview(self.castCollectionViewHeaderButton)
        return view
    }()
    
    private lazy var castCollectionViewHeaderTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cast".localized()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    private lazy var castCollectionViewHeaderButton: MWRoundedButton =
        MWRoundedButton(text: "All".localized(), image: UIImage(named: "nextIcon"))
    
    private lazy var castCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.castCollectionViewItemSize
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = self.contentInsets
        return layout
    }()
    
    private lazy var castCollectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect(),
                                    collectionViewLayout: self.castCollectionViewFlowLayout)
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
    
    override func initController() {
        super.initController()
        
        self.navigationItem.largeTitleDisplayMode = .never
        
        self.view.addSubview(self.scrollView)
        self.scrollView.isHidden = true
        
        self.dispatchGroup.notify(queue: DispatchQueue.main) {
            self.setup()
            self.makeAllConstraints()
            self.scrollView.isHidden = false
        }
    }
    
    // MARK: - constraints
    
    private func makeAllConstraints() {
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.movieCardView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalTo(self.view)
        }
        self.movieCardView.makeInternalConstraints()
        self.moviePlayer.snp.makeConstraints { (make) in
            make.top.equalTo(self.movieCardView.snp.bottom).offset(18)
            make.left.right.equalTo(self.view).inset(self.contentInsets)
            make.height.equalTo(202)
        }
        self.descriptionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.moviePlayer.snp.bottom).offset(24)
            make.left.right.equalTo(self.view).inset(self.contentInsets)
        }
        self.makeInternalDescriptionViewConstraints()
        self.castView.snp.makeConstraints { (make) in
            make.top.equalTo(self.descriptionView.snp.bottom).offset(24)
            make.left.right.equalTo(self.view)
        }
        self.makeInternalCastViewConstraints()
    }
    
    private func makeInternalDescriptionViewConstraints() {
        self.descriptionTitleLabel.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
        self.descriptionSubtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.descriptionTitleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
        }
        self.descriptionTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.descriptionSubtitleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func makeInternalCastViewConstraints() {
        self.castCollectionViewHeader.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(self.contentInsets)
            make.right.equalToSuperview().inset(26)
        }
        self.castCollectionViewHeaderTitleLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.right.lessThanOrEqualTo(self.castCollectionViewHeaderButton).inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
        self.castCollectionViewHeaderButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.size.equalTo(self.castCollectionViewHeaderButtonSize)
        }
        self.castCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.castCollectionViewHeader.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(self.castCollectionViewItemSize.height)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - functions
    
    private func setup() {
        guard let movie = self.movie, let details = movie.details else { return }
        
        self.movieCardView.setup(movie)

        self.descriptionSubtitleLabel.text = "X minutes".localized(args: details.runtime ?? 0)
        self.descriptionTextLabel.text = movie.overview
        self.castCollectionView.reloadData()
    }
}

extension MWMovieDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let cast = self.movie?.details?.credits?.cast else { return 0 }
        return cast.count >= 10 ? 10 : cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: MWActorCollectionViewCell.reuseId,
                                 for: indexPath)
            as? MWActorCollectionViewCell ?? MWActorCollectionViewCell()
        guard let actor = self.movie?.details?.credits?.cast[indexPath.row] else { return cell }
        
        cell.setup(actor: actor)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        (cell as? MWActorCollectionViewCell)?.imageView.kf.cancelDownloadTask()
    }
}
