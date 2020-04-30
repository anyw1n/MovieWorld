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

    private let descriptionView: MWDescriptionView = MWDescriptionView(additionalInfoEnabled: true)

    private lazy var castView: MWCollectionViewWithHeader<MWActor, MWActorCollectionViewCell> = {
        let view = MWCollectionViewWithHeader<MWActor, MWActorCollectionViewCell>()
        view.sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 26)
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
        self.movieCardView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalTo(self.view)
        }
        self.movieCardView.makeConstraints()
        self.moviePlayerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.movieCardView.snp.bottom).offset(18)
            make.left.right.equalTo(self.view).inset(self.contentInsets)
        }
        self.moviePlayerView.makeInternalConstraints()
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
    }

    // MARK: - functions

    @objc private func allCastButtonTapped() {
        let controller = MWCastViewController()
        controller.credits = self.movie?.details?.credits
        MWI.sh.push(controller)
    }

    private func setup() {
        guard let movie = self.movie, let details = movie.details else { return }

        self.movieCardView.setup(movie)

        let subtitle = "X minutes".localized(args: movie.details?.runtime ?? 0)

        if let youtubeVideo = details.videos?.first(where: { $0.site == "YouTube" }) {
            self.moviePlayerView.setup(video: youtubeVideo)

            YTApi.sh.request(
            videoId: youtubeVideo.key) { [weak self] (response: YoutubeDataVideoContentDetails) in
                self?.descriptionView.definitionLabel.text =
                    response.contentDetails.definition.uppercased()
            }
        }

        self.descriptionView.setup(title: "Description".localized(),
                                   definition: "",
                                   subtitle: subtitle,
                                   text: movie.overview)

        if let cast = details.credits?.cast {
            self.castView.setup(title: "Cast".localized(),
                                items: cast,
                                itemSpacing: 16,
                                cellTapped: { (indexPath) in
                                    let controller = MWActorDetailsViewController()
                                    controller.actor = cast[indexPath.row]
                                    MWI.sh.push(controller)
            },
                                allButtonTapped: {
                                    let controller = MWCastViewController()
                                    controller.credits = details.credits
                                    MWI.sh.push(controller)
            })
        }

        if let images = details.images,
            let videos = details.videos?.filter({ $0.site == "YouTube" }) {

            let items: [Mediable] = videos + images.backdrops + images.posters
            self.galleryView.setup(items: items)
        }
    }
}
