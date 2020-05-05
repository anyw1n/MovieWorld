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

        private static let popularSection =
            MWSection(name: "Popular".localized(), url: URLPaths.popularMovies)

        private static let newSection =
            MWSection(name: "New".localized(),
                      url: URLPaths.discoverMovies,
                      parameters: ["release_date.lte": Date().formatted(dateFormat: "yyyy-MM-dd"),
                                   "sort_by": "release_date.desc"])

        private static let animatedSection =
            MWSection(name: "Animated movies".localized(),
                      url: URLPaths.discoverMovies,
                      parameters: ["release_date.lte": Date().formatted(dateFormat: "yyyy-MM-dd"),
                                   "sort_by": "popularity.desc"],
                      genreIds: [MWS.sh.animatedMoviesGenreId])

        private static let upcomingSection =
            MWSection(name: "Upcoming".localized(), url: URLPaths.upcomingMovies)

        case popular, new, animated, upcoming

        func get() -> MWSection {
            switch self {
            case .popular:
                return Sections.popularSection
            case .new:
                return Sections.newSection
            case .animated:
                return Sections.animatedSection
            case .upcoming:
                return Sections.upcomingSection
            }
        }
    }

    // MARK: - variables

    private let sections: [Sections] = Sections.allCases

    private let dispatchGroup = DispatchGroup()

    // MARK: - gui variables

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect(), style: .grouped)
        view.delegate = self
        view.dataSource = self
        view.register(MWCollectionTableViewCell.self,
                      forCellReuseIdentifier: MWCollectionTableViewCell.reuseID)
        view.register(MWRetryTableViewCell.self,
                      forCellReuseIdentifier: MWRetryTableViewCell.reuseID)
        view.register(MWTableViewHeader.self,
                      forHeaderFooterViewReuseIdentifier: MWTableViewHeader.reuseID)
        view.separatorStyle = .none
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.refreshControl = self.refreshControl
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
            make.edges.equalToSuperview()
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

    @objc private func allButtonTapped(sender: UIButton) {
        let controller = MWMovieListViewController()
        controller.section = self.sections[sender.tag].get().copy() as? MWSection
        MWI.sh.push(controller)
    }

    private func loadMovies(into sections: [Sections]) {
        for (i, sectionCase) in sections.enumerated() {
            let section = sectionCase.get()

            self.dispatchGroup.enter()

            MWN.sh.request(url: section.url,
                           queryParameters: section.requestParameters,
                           successHandler: { [weak self] (response: MWMovieRequestResult) in
                            section.loadResults(from: response)
                            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: i)],
                                                       with: .automatic)
                            self?.dispatchGroup.leave()
            }) { [weak self] error in
                error.printInConsole()
                self?.dispatchGroup.leave()
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension MWMainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: MWTableViewHeader.reuseID)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let view = view as? MWTableViewHeader else { return }
        view.titleLabel.text = self.sections[section].get().name
        view.rightButton.addTarget(self,
                                   action: #selector(self.allButtonTapped),
                                   for: .touchUpInside)
        view.rightButton.tag = section
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 68
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 237
    }
}

// MARK: - UITableViewDataSource

extension MWMainViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.sections[indexPath.section].get().movies.count != 0 {
            let cell =
                tableView.dequeueReusableCell(withIdentifier: MWCollectionTableViewCell.reuseID,
                                              for: indexPath)
            (cell as? MWCollectionTableViewCell)?.movies =
                self.sections[indexPath.section].get().movies
            (cell as? MWCollectionTableViewCell)?.collectionView.reloadData()
            cell.setNeedsUpdateConstraints()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MWRetryTableViewCell.reuseID,
                                                     for: indexPath)
            (cell as? MWRetryTableViewCell)?.retryTapped = { [weak self] in
                guard let self = self else { return }
                self.loadMovies(into: [self.sections[indexPath.section]])
            }
            cell.setNeedsUpdateConstraints()
            return cell
        }
    }
}
