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

    private var section: MWSection?

    private var isRequestBusy: Bool = false
    private var isHeaderEnabled: Bool = true

    // MARK: - gui variables

    private lazy var tagCollectionView = MWTagsCollectionView()

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

    private lazy var retryView: MWRetryView = {
        let view = MWRetryView()
        view.delegate = self
        return view
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refreshAction), for: .valueChanged)
        refresh.tintColor = UIColor(named: "accentColor")
        return refresh
    }()

    // MARK: - init

    override func initController() {
        super.initController()

        self.navigationItem.title = self.section?.name
        self.view.addSubview(self.retryView)
        self.view.insertSubview(self.tableView, at: 0)
        self.makeConstraints()

        if let section = self.section, section.pagesLoaded == 0, !section.isStaticSection {
            self.loadMovies(nextPage: true)
        }
    }

    // MARK: - constraints

    private func makeConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.retryView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                .offset(self.isHeaderEnabled ? MWTagsCollectionView.height : 0)
            make.left.right.bottom.equalToSuperview()
        }
        self.retryView.makeConstraints()
    }

    // MARK: - functions

    private func reloadData() {
        if self.section?.movies.isEmpty ?? true {
            self.tableView.isScrollEnabled = false
            self.retryView.show(retryButtonEnabled: false)
        } else {
            self.tableView.isScrollEnabled = true
            self.retryView.hide()
            self.tableView.reloadData()
        }
    }

    private func loadMovies(nextPage: Bool,
                            enableSpinner: Bool = true,
                            completionHandler: (() -> Void)? = nil) {
        guard !self.isRequestBusy,
            let section = self.section else { return }
        self.isRequestBusy = true

        if enableSpinner {
            self.startSpinner()
            self.tableView.isScrollEnabled = false
        }
        if !nextPage {
            self.section?.clear()
            self.tableView.reloadData()
        }

        section.loadMovies(completionHandler: { [weak self] in
            guard let self = self else { return }
            self.isRequestBusy = false
            self.reloadData()
            self.stopSpinner()
            completionHandler?()
        }) { [weak self] (error) in
            guard let self = self else { return }
            switch error {
            case .unknown(error: let aferror) where aferror.isExplicitlyCancelledError:
                break
            default:
                self.stopSpinner()
                self.tableView.isScrollEnabled = false
                self.retryView.show(retryButtonEnabled: true)
            }
            self.isRequestBusy = false
            completionHandler?()
        }
    }

    // MARK: - setters

    func setup(section: MWSection?, isHeaderEnabled: Bool = true) {
        guard let section = section else { return }

        self.section = section
        self.isHeaderEnabled = isHeaderEnabled

        if isHeaderEnabled {
            self.tagCollectionView.setup(section: section) { [weak self] in
                guard let self = self else { return }
                self.isRequestBusy = false
                self.loadMovies(nextPage: false)
            }
        }
    }

    // MARK: - actions

    @objc private func refreshAction() {
        self.loadMovies(nextPage: false,
                        enableSpinner: false) { self.tableView.refreshControl?.endRefreshing() }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MWMovieListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.section?.movies.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MWMovieCardTableViewCell.reuseId,
                                                 for: indexPath)

        guard let section = self.section else { return cell }
        (cell as? MWMovieCardTableViewCell)?.setup(section.movies[indexPath.row]) {
            cell.setNeedsUpdateConstraints()
        }

        if indexPath.row == section.movies.count - 5,
            !section.isStaticSection,
            section.pagesLoaded != section.totalPages {
            self.loadMovies(nextPage: true, enableSpinner: false)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = MWMovieDetailsViewController()
        controller.movie = self.section?.movies[indexPath.row]
        MWI.sh.push(controller)
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? MWMovieCardTableViewCell)?.cancelDownloadTask()
        guard let section = self.section, !section.movies.isEmpty else { return }
        section.movies[indexPath.row].detailsLoaded = nil
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.isHeaderEnabled ? self.tagCollectionView : nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.isHeaderEnabled ? MWTagsCollectionView.height : CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

// MARK: - MWRetryViewDelegate

extension MWMovieListViewController: MWRetryViewDelegate {

    func retryButtonTapped() {
        self.loadMovies(nextPage: false)
    }

    func message() -> String? { self.section?.message }
}
