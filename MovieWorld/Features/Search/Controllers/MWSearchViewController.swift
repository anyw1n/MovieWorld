//
//  MWSearchViewController.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/22/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWSearchViewController: MWViewController {

    // MARK: - variables

    private var section = MWSection(name: "Movies", url: URLPaths.searchMovies, category: .movie)

    private var isRequestBusy: Bool = false
    private var previousText: String = ""

    // MARK: - gui variables

    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.barTintColor = UIColor(named: "accentColor")
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.tintColor = UIColor(named: "accentColor")
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
            .defaultTextAttributes = [.foregroundColor: UIColor(named: "textColor") ?? UIColor.black]
        return controller
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(MWMovieCardTableViewCell.self,
                      forCellReuseIdentifier: MWMovieCardTableViewCell.reuseId)
        view.separatorStyle = .none
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        return view
    }()

    private lazy var placeholder: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = UIColor(named: "textColor")
        label.alpha = 0.5
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Enter a request".localized()
        return label
    }()

    private lazy var retryView: MWRetryView = {
        let view = MWRetryView()
        view.delegate = self
        return view
    }()

    // MARK: - init

    override func initController() {
        super.initController()

        self.navigationItem.title = "Search".localized()

        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true

        self.view.insertSubview(self.tableView, at: 0)
        self.view.addSubview(self.retryView)
        self.view.addSubview(self.placeholder)
        self.makeConstraints()
    }

    // MARK: - constraints

    private func makeConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
        }
        self.placeholder.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.top.left.greaterThanOrEqualToSuperview()
            make.right.bottom.lessThanOrEqualToSuperview()
        }

        self.retryView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
        self.retryView.makeConstraints()
    }

    // MARK: - functions

    private func reloadData() {
        if self.section.movies.isEmpty {
            self.retryView.show(retryButtonEnabled: false)
        } else {
            self.retryView.hide()
            self.tableView.reloadData()
        }
    }

    private func loadMovies(nextPage: Bool, enableSpinner: Bool = true) {
        guard !self.isRequestBusy else { return }
        self.isRequestBusy = true

        if enableSpinner {
            self.startSpinner()
        }
        if !nextPage {
            self.section.clear()
            self.tableView.reloadData()
        }

        self.section.loadMovies(completionHandler: { [weak self] in
            guard let self = self else { return }
            self.isRequestBusy = false
            self.reloadData()
            self.stopSpinner()
        }) { [weak self] (error) in
            guard let self = self else { return }
            switch error {
            case .unknown(error: let aferror) where aferror.isExplicitlyCancelledError:
                break
            default:
                self.stopSpinner()
                self.retryView.show(retryButtonEnabled: true)
            }
            self.isRequestBusy = false
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MWSearchViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.section.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MWMovieCardTableViewCell.reuseId,
                                                 for: indexPath)
        (cell as? MWMovieCardTableViewCell)?.setup(self.section.movies[indexPath.row]) {
            cell.setNeedsUpdateConstraints()
        }

        if indexPath.row == self.section.movies.count - 5,
        self.section.pagesLoaded != self.section.totalPages {
            self.loadMovies(nextPage: true, enableSpinner: false)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? MWMovieCardTableViewCell)?.cancelDownloadTask()
        if !self.section.movies.isEmpty {
            section.movies[indexPath.row].detailsLoaded = nil
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = MWMovieDetailsViewController()
        controller.movie = self.section.movies[indexPath.row]
        MWI.sh.push(controller)
    }
}

// MARK: - UISearchResultsUpdating

extension MWSearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text != self.previousText else { return }
        self.previousText = text
        if !text.isEmpty {
            self.placeholder.isHidden = true
            self.section.requestParameters["query"] = text
            self.isRequestBusy = false
            self.loadMovies(nextPage: false)
        } else {
            self.retryView.hide()
            self.placeholder.isHidden = false
            self.section.clear()
            self.tableView.reloadData()
        }
    }
}

// MARK: - MWRetryViewDelegate

extension MWSearchViewController: MWRetryViewDelegate {

    func retryButtonTapped() {
        self.loadMovies(nextPage: false)
    }

    func message() -> String? { self.section.message }
}
