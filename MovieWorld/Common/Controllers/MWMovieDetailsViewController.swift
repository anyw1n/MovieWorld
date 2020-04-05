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
    
    var movie: Movieable?
    
    // MARK: - gui variables
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private lazy var movieCardView: MWMovieCardView = MWMovieCardView(movie: self.movie)

    // MARK: - init
    
    override func initController() {
        super.initController()
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.movieCardView)
        self.makeConstraints()
    }
    
    // MARK: - constraints
    
    private func makeConstraints() {
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.movieCardView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalTo(self.view)
        }
    }
}
