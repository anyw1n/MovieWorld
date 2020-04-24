//
//  MWActorDetailsViewController.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/23/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWActorDetailsViewController: MWViewController {
    
    // MARK: - variables
    
    private let dispatchGroup = DispatchGroup()
    private let offset = 16
    var actor: MWActor? {
        didSet {
            self.dispatchGroup.enter()
            self.actor?.requestDetails([.movieCredits, .tvCredits]) { [weak self] in
                self?.dispatchGroup.leave()
            }
        }
    }
    
    // MARK: - gui variables

    private let actorCardView: MWActorCardView = MWActorCardView()
    
    private let filmographyView = MWCollectionViewWithHeader<Movieable, MWMovieCardCollectionViewCell>()
    
    private let biographyView: MWDescriptionView = MWDescriptionView(additionalInfoEnabled: false)
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.addSubview(self.actorCardView)
        view.addSubview(self.filmographyView)
        view.addSubview(self.biographyView)
        return view
    }()
    
    // MARK: - init
    
    override func initController() {
        super.initController()
        
        self.view.addSubview(self.scrollView)
        self.scrollView.isHidden = true
        
        self.dispatchGroup.notify(queue: DispatchQueue.main) {
            self.setup()
            self.makeConstraints()
            self.scrollView.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.largeTitleDisplayMode = .always
    }
    
    // MARK: - constraints
    
    private func makeConstraints() {
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.actorCardView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(self.offset)
            make.left.right.equalTo(self.view)
        }
        self.actorCardView.makeConstraints()
        self.filmographyView.snp.makeConstraints { (make) in
            make.top.equalTo(self.actorCardView.snp.bottom)
            make.left.right.equalTo(self.view)
        }
        self.filmographyView.makeConstraints()
        self.biographyView.snp.makeConstraints { (make) in
            make.top.equalTo(self.filmographyView.snp.bottom)
            make.left.right.equalTo(self.view)
            make.bottom.equalToSuperview().offset(-10)
        }
        self.biographyView.makeConstraints()
    }
    
    // MARK: - functions
    
    private func setup() {
        guard let actor = self.actor else { return }
        
        self.actorCardView.setup(actor: actor)
        
        if let movies = actor.details?.movieCredits?.cast,
            let tv = actor.details?.tvCredits?.cast {
            let items: [Movieable] = movies + tv
            self.filmographyView.setup(title: "Filmography".localized(),
                                       items: items,
                                       itemSpacing: 8,
                                       cellTapped: { (indexPath) in
                                        let controller = MWMovieDetailsViewController()
                                        controller.movie = items[indexPath.row]
                                        MWI.sh.push(controller)
            },
                                       allButtonTapped: nil)
        }
        
        var title = "Actor"
        if let jobs = actor.details?.jobs {
            title.append(", \(jobs.joined(separator: ", "))")
        }
        self.biographyView.setup(title: title, text: actor.details?.biography)
    }
}
