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

    var actor: MWActor? {
        didSet {
            self.retryButtonTapped()
        }
    }

    private let offset = 16

    private var error: String?

    private lazy var filmography: [Movieable] = {
        var items: [Movieable] = []
        if let movies = self.actor?.details?.movieCredits?.cast {
            items.append(contentsOf: movies)
        }
        if let tv = self.actor?.details?.tvCredits?.cast {
            items.append(contentsOf: tv)
        }
        return items
    }()

    // MARK: - gui variables

    private let actorCardView: MWActorCardView = MWActorCardView()

    private lazy var filmographyView: MWCollectionViewWithHeader<Movieable, MWMovieCardCollectionViewCell> = {
        let view = MWCollectionViewWithHeader<Movieable, MWMovieCardCollectionViewCell>()
        view.delegate = self
        return view
    }()

    private let biographyView: MWDescriptionView = MWDescriptionView(additionalInfoEnabled: false)

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.addSubview(self.actorCardView)
        view.addSubview(self.filmographyView)
        view.addSubview(self.biographyView)
        view.alpha = 0
        return view
    }()

    private lazy var retryView: MWRetryView = {
        let view = MWRetryView()
        view.delegate = self
        return view
    }()

    // MARK: - init

    override func initController() {
        super.initController()
        self.startSpinner()

        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.retryView)
        self.makeConstraints()
    }

    // MARK: - lifecycle

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
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
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
        self.retryView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
        self.retryView.makeConstraints()
    }

    // MARK: - functions

    private func setup() {
        guard let actor = self.actor else { return }
        self.stopSpinner()

        self.actorCardView.setup(actor: actor) {
            guard let path = actor.profilePath else { return }
            let controller = MWFullscreenImageViewController()
            controller.setup(TMDBPath: path)
            self.present(controller, animated: true)
        }

        if self.filmography.isEmpty { self.error = "Nothing to show here..".localized() }
        self.filmographyView.setup(title: "Filmography".localized(),
                                   items: self.filmography,
                                   retryButtonEnabled: false)

        var title = "Actor"
        if let jobs = actor.details?.jobs {
            title.append(", \(jobs.joined(separator: ", "))")
        }
        self.biographyView.setup(title: title, text: actor.details?.biography)
    }
}

// MARK: - MWCollectionViewWithHeaderDelegate

extension MWActorDetailsViewController: MWCollectionViewWithHeaderDelegate {

    func cellTapped(indexPath: IndexPath) {
        let controller = MWMovieDetailsViewController()
        controller.movie = self.filmography[indexPath.row]
        MWI.sh.push(controller)
    }

    func allButtonTapped() {
        let controller = MWMovieListViewController()
        controller.section = MWSection(name: "Filmography".localized(),
                                       movies: self.filmography,
                                       isStaticSection: true)
        MWI.sh.push(controller)
    }
}

// MARK: - MWRetryViewDelegate

extension MWActorDetailsViewController: MWRetryViewDelegate {

    func retryButtonTapped() {
        self.actor?.requestDetails([.movieCredits, .tvCredits],
                                   completionHandler: { [weak self] in
                                    self?.setup()
                                    UIView.animate(withDuration: 0.3) {
                                        self?.scrollView.alpha = 1
                                    }
                                    self?.retryView.hide()
        }) { [weak self] (error) in
            self?.error = error.getDescription()
            self?.retryView.show()
        }
    }

    func message() -> String? { self.error }
}
