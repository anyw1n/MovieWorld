//
//  MWMovieListViewController.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/14/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWMovieListViewController: MWViewController {

    // MARK: - variables

    var section: MWSection? {
        didSet {
            guard let section = self.section else { return }
            self.tagCollectionView.setup(section: section) { [weak self] in
                self?.refreshTableView()
            }
        }
    }

    private var isRequestBusy: Bool = false

    // MARK: - gui variables

    private let tagCollectionView = MWTagsCollectionView()

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect(), style: .grouped)
        view.delegate = self
        view.dataSource = self
        view.register(MWMovieCardTableViewCell.self,
                      forCellReuseIdentifier: MWMovieCardTableViewCell.reuseId)
        view.separatorStyle = .none
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.refreshControl = self.refreshControl
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

        self.navigationItem.title = self.section?.name
        self.view.addSubview(self.tableView)
        self.makeConstraints()

        if let section = self.section, section.pagesLoaded == 0, !section.isStaticSection {
            self.loadMovies()
        }
    }

    // MARK: - constraints

    private func makeConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - functions

    private func loadMovies(completionHandler: (() -> Void)? = nil) {
        guard !self.isRequestBusy,
            let section = self.section,
            !section.isStaticSection,
            section.pagesLoaded != section.totalPages,
            let category = section.category else { return }
        self.isRequestBusy = true

        switch category {
        case .movie:
            self.requestMovies(
            page: (section.pagesLoaded) + 1) { [weak self] (response: MWMovieRequestResult<MWMovie>) in
                guard let self = self else { return }
                self.isRequestBusy = false
                section.loadResults(from: response)
                self.tableView.reloadData()
                completionHandler?()
            }
        case .tv:
            self.requestMovies(
            page: (section.pagesLoaded) + 1) { [weak self] (response: MWMovieRequestResult<MWShow>) in
                guard let self = self else { return }
                self.isRequestBusy = false
                section.loadResults(from: response)
                self.tableView.reloadData()
                completionHandler?()
            }
        }
    }

    private func requestMovies<T>(page: Int, completion: @escaping (MWMovieRequestResult<T>) -> Void) {
        guard let section = self.section, let url = section.url else { return }
        section.requestParameters["page"] = page
        MWN.sh.request(url: url,
                       queryParameters: section.requestParameters,
                       successHandler: { (response: MWMovieRequestResult) in
                        completion(response)
        }, errorHandler: { (error) in
            error.printInConsole()
        })
    }

    @objc private func refreshTableView() {
        guard let section = self.section else { return }
        section.clearResults()
        self.tableView.reloadData()

        if section.isStaticSection,
            let originalMovies = section.originalMovies,
            let genreIds = section.genreIds {
            section.movies = originalMovies.filter { (movie) -> Bool in
                for id in genreIds {
                    if !movie.genreIds.contains(Int(id)) { return false }
                }
                return true
            }
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        } else { self.loadMovies(completionHandler: { self.refreshControl.endRefreshing() }) }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MWMovieListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.section?.movies.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(withIdentifier: MWMovieCardTableViewCell.reuseId,
                                          for: indexPath)

        guard let section = self.section else { return cell }
        (cell as? MWMovieCardTableViewCell)?.layout.setup(section.movies[indexPath.row]) {
            cell.setNeedsUpdateConstraints()
        }

        if indexPath.row == section.movies.count - 5, !section.isStaticSection {
            self.loadMovies()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = MWMovieDetailsViewController()
        controller.movie = self.section?.movies[indexPath.row]
        MWI.sh.push(controller)
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? MWMovieCardTableViewCell)?.layout.posterImageView.kf.cancelDownloadTask()
        guard let section = self.section, !section.movies.isEmpty else { return }
        section.movies[indexPath.row].detailsLoaded = nil
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.tagCollectionView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return MWTagsCollectionView.height
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
