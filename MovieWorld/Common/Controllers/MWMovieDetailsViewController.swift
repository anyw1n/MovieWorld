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
    
    private let moviePlayerView: MWMoviePlayerView = MWMoviePlayerView()
    
    private let descriptionView: MWDescriptionView = MWDescriptionView()
    
    private let castView: MWCastView = MWCastView()

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.addSubview(self.movieCardView)
        view.addSubview(self.moviePlayerView)
        view.addSubview(self.descriptionView)
        view.addSubview(self.castView)
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
        self.moviePlayerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.movieCardView.snp.bottom).offset(18)
            make.left.right.equalTo(self.view).inset(self.contentInsets)
        }
        self.moviePlayerView.makeInternalConstraints()
        self.descriptionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.moviePlayerView.snp.bottom).offset(24)
            make.left.right.equalTo(self.view).inset(self.contentInsets)
        }
        self.descriptionView.makeInternalConstraints()
        self.castView.snp.makeConstraints { (make) in
            make.top.equalTo(self.descriptionView.snp.bottom).offset(24)
            make.left.right.equalTo(self.view)
            make.bottom.equalToSuperview()
        }
        self.castView.makeInternalConstraints()
    }
    
    // MARK: - functions
    
    private func setup() {
        guard let movie = self.movie, let cast = movie.details?.credits?.cast else { return }
        
        self.movieCardView.setup(movie)
        
        self.descriptionView.setup(movie)
        self.castView.setup(cast: cast)
    }
}
