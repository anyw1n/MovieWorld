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

    var movie: Movieable? {
        didSet {
            self.retryButtonTapped()
        }
    }

    private let contentInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

    private var error: String?

    // MARK: - gui variables

    private let movieCardView: MWMovieCardView = MWMovieCardView()

    private let moviePlayerView: MWMoviePlayerView = MWMoviePlayerView()

    private let descriptionView: MWDescriptionView = MWDescriptionView(additionalInfoEnabled: true)

    private lazy var castView: MWCollectionViewWithHeader<MWActor, MWActorCollectionViewCell> = {
        let view = MWCollectionViewWithHeader<MWActor, MWActorCollectionViewCell>()
        view.sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 26)
        view.delegate = self
        return view
    }()

    private lazy var galleryView: MWGalleryView = MWGalleryView(in: self)

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.addSubview(self.movieCardView)
        view.addSubview(self.moviePlayerView)
        view.addSubview(self.descriptionView)
        view.addSubview(self.castView)
        view.addSubview(self.galleryView)
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
        self.movieCardView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalTo(self.view)
        }
        self.movieCardView.makeConstraints()
        self.moviePlayerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.movieCardView.snp.bottom).offset(18)
            make.left.right.equalTo(self.view).inset(self.contentInsets)
        }
        self.moviePlayerView.makeConstraints()
        self.descriptionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.moviePlayerView.snp.bottom)
            make.left.right.equalTo(self.view)
        }
        self.descriptionView.makeConstraints()
        self.castView.snp.makeConstraints { (make) in
            make.top.equalTo(self.descriptionView.snp.bottom)
            make.left.right.equalTo(self.view)
        }
        self.castView.makeConstraints()
        self.galleryView.snp.makeConstraints { (make) in
            make.top.equalTo(self.castView.snp.bottom).offset(24)
            make.left.right.equalTo(self.view)
            make.bottom.equalToSuperview().offset(-10)
        }
        self.galleryView.makeConstraints()
        self.retryView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
        self.retryView.makeConstraints()
    }

    // MARK: - functions

    private func setup() {
        guard let movie = self.movie, let details = movie.details else { return }
        self.stopSpinner()

        self.movieCardView.setup(movie)

        if let youtubeVideo = details.videos?.first(where: { $0.site == "YouTube" }) {
            self.moviePlayerView.setup(video: youtubeVideo)

            YTApi.sh.request(
            videoId: youtubeVideo.key) { [weak self] (response: YoutubeDataVideoContentDetails) in
                self?.descriptionView.definitionLabel.text =
                    response.contentDetails.definition.uppercased()
            }
        }

        let subtitle = "X minutes".localized(args: movie.details?.runtime ?? 0)
        self.descriptionView.setup(title: "Description".localized(),
                                   definition: "",
                                   subtitle: subtitle,
                                   text: movie.overview)

        if let cast = details.credits?.cast {
            self.error = "Nothing to show here..".localized()
            self.castView.setup(title: "Cast".localized(),
                                items: cast,
                                itemSpacing: 16,
                                retryButtonEnabled: false)
        }

        if let images = details.images,
            let videos = details.videos?.filter({ $0.site == "YouTube" }) {

            let items: [Mediable] = videos + images.backdrops + images.posters
            self.galleryView.setup(items: items)
        }
    }
}

// MARK: - MWCollectionViewWithHeaderDelegate

extension MWMovieDetailsViewController: MWCollectionViewWithHeaderDelegate {

    func cellTapped(indexPath: IndexPath) {
        if let cast = self.movie?.details?.credits?.cast {
            let controller = MWActorDetailsViewController()
            controller.actor = cast[indexPath.row]
            MWI.sh.push(controller)
        }
    }

    func allButtonTapped() {
        if let credits = self.movie?.details?.credits {
            let controller = MWCastViewController()
            controller.credits = credits
            MWI.sh.push(controller)
        }
    }
}

// MARK: - MWRetryViewDelegate

extension MWMovieDetailsViewController: MWRetryViewDelegate {

    func retryButtonTapped() {
        self.movie?.requestDetails([.credits, .images, .videos],
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
