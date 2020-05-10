//
//  MWMainViewController.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/22/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWMainViewController: MWViewController {

    // MARK: - enum

    private enum Sections: CaseIterable {

        private static let currentDateString = Date().formatted(dateFormat: "yyyy-MM-dd")

        private static let newSection =
            MWSection(name: "New".localized(),
                      url: URLPaths.discoverMovies,
                      category: .movie,
                      parameters: ["release_date.lte": Sections.currentDateString,
                                   "sort_by": "release_date.desc"])

        private static let moviesSection =
            MWSection(name: "Movies".localized(),
                      url: URLPaths.discoverMovies,
                      category: .movie,
                      parameters: ["release_date.lte": Sections.currentDateString,
                                   "sort_by": "popularity.desc"])

        private static let tvSection =
            MWSection(name: "Series and shows".localized(),
                      url: URLPaths.discoverTVs,
                      category: .tv,
                      parameters: ["first_air_date.lte": Sections.currentDateString,
                                   "sort_by": "popularity.desc"])

        private static let animatedSection =
            MWSection(name: "Animated movies".localized(),
                      url: URLPaths.discoverMovies,
                      category: .movie,
                      parameters: ["release_date.lte": Sections.currentDateString,
                                   "sort_by": "popularity.desc"],
                      genreIds: [MWS.sh.animatedMoviesGenreId])

        case new, movies, tv, animated

        func get() -> MWSection {
            switch self {
            case .new:
                return Sections.newSection
            case .movies:
                return Sections.moviesSection
            case .tv:
                return Sections.tvSection
            case .animated:
                return Sections.animatedSection
            }
        }
    }

    // MARK: - variables

    private let sections: [Sections] = Sections.allCases

    private let dispatchGroup = DispatchGroup()

    private let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)

    // MARK: - gui variables

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(MWCollectionTableViewCell.self,
                      forCellReuseIdentifier: MWCollectionTableViewCell.reuseId)
        view.separatorStyle = .none
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.refreshControl = self.refreshControl
        view.contentInset = self.contentInsets
        view.alpha = 0
        return view
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refreshTableView), for: .valueChanged)
        refresh.tintColor = UIColor(named: "accentColor")
        return refresh
    }()

    // MARK: - init

    override func initController() {
        super.initController()
        self.navigationItem.title = "Movie World"

        self.loadMovies(into: self.sections)
        self.view.addSubview(self.tableView)
        self.makeConstraints()

        self.dispatchGroup.notify(queue: DispatchQueue.main) {
            UIView.animate(withDuration: 0.3) { self.tableView.alpha = 1 }
        }
    }

    // MARK: - constraints

    private func makeConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }

    // MARK: - functions

    @objc private func refreshTableView() {
        UIView.animate(withDuration: 0.3) { self.tableView.alpha = 0 }

        self.loadMovies(into: Sections.allCases)
        self.dispatchGroup.notify(queue: DispatchQueue.main) {
            UIView.animate(withDuration: 0.3) { self.tableView.alpha = 1 }
            self.refreshControl.endRefreshing()
        }
    }

    private func loadMovies(into sections: [Sections]) {
        for (i, sectionCase) in sections.enumerated() {
            let section = sectionCase.get()
            guard let url = section.url, let category = section.category else { return }

            self.dispatchGroup.enter()

            switch category {
            case .movie:
                MWN.sh.request(
                    url: url,
                    queryParameters: section.requestParameters,
                    successHandler: { [weak self] (response: MWMovieRequestResult<MWMovie>) in
                        section.loadResults(from: response)
                        self?.tableView.reloadRows(at: [IndexPath(row: i, section: 0)],
                                                   with: .automatic)
                        self?.dispatchGroup.leave()
                    }, errorHandler: { [weak self] error in
                        error.printInConsole()
                        self?.dispatchGroup.leave()
                })
            case .tv:
                MWN.sh.request(
                    url: url,
                    queryParameters: section.requestParameters,
                    successHandler: { [weak self] (response: MWMovieRequestResult<MWShow>) in
                        section.loadResults(from: response)
                        self?.tableView.reloadRows(at: [IndexPath(row: i, section: 0)],
                                                   with: .automatic)
                        self?.dispatchGroup.leave()
                    }, errorHandler: { [weak self] error in
                        error.printInConsole()
                        self?.dispatchGroup.leave()
                })
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MWMainViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView
            .dequeueReusableCell(withIdentifier: MWCollectionTableViewCell.reuseId,
                                 for: indexPath)

        (cell as? MWCollectionTableViewCell)?
            .setup(section: self.sections[indexPath.row].get()) { [weak self] in
                guard let self = self else { return }
                self.loadMovies(into: [self.sections[indexPath.row]])
        }
        cell.setNeedsUpdateConstraints()
        return cell
    }
}
