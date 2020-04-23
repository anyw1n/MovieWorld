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
    private let biographyInsets = UIEdgeInsets(top: 0, left: 16, bottom: 10, right: 16)
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
    
    private let filmographyView: MWFilmographyView = MWFilmographyView()
    
    private lazy var biographyView: UIView = {
        let view = UIView()
        view.addSubview(self.titleBiographyLabel)
        view.addSubview(self.textBiographyLabel)
        return view
    }()
    
    private lazy var titleBiographyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor(named: "textColor")
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var textBiographyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor(named: "textColor")
        label.numberOfLines = 0
        return label
    }()
    
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
            make.top.equalTo(self.actorCardView.snp.bottom).offset(24)
            make.left.right.equalTo(self.view)
        }
        self.filmographyView.makeConstraints()
        self.biographyView.snp.makeConstraints { (make) in
            make.top.equalTo(self.filmographyView.snp.bottom).offset(24)
            make.left.right.equalTo(self.view)
            make.bottom.equalToSuperview()
        }
        self.titleBiographyLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(self.offset)
            make.right.lessThanOrEqualToSuperview().offset(-self.offset)
        }
        self.textBiographyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleBiographyLabel.snp.bottom).offset(self.offset)
            make.left.right.equalTo(self.view).inset(self.biographyInsets)
            make.bottom.equalToSuperview().inset(self.biographyInsets)
        }
    }
    
    // MARK: - functions
    
    private func setup() {
        guard let actor = self.actor else { return }
        
        self.actorCardView.setup(actor: actor)
        self.filmographyView.setup(actor: actor)
        if let jobs = actor.details?.jobs {
            self.titleBiographyLabel.text = "Actor, \(jobs.joined(separator: ", "))"
        } else {
            self.titleBiographyLabel.text = "Actor"
        }
        self.textBiographyLabel.text = actor.details?.biography
    }
}
