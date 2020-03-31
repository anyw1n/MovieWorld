//
//  MWMainViewController.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/22/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWMainViewController: MWViewController {
    
    //MARK: - variables
    
    private let dispatchGroup = DispatchGroup()
    private lazy var sections: [MWSection] = {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return [MWSection(name: "New".localized(),
                          url: URLPaths.discoverMovies,
                          category: .movie,
                          parameters: ["release_date.lte": formatter.string(from: currentDate),
                                       "sort_by": "release_date.desc"]),
                MWSection(name: "Movies".localized(),
                          url: URLPaths.discoverMovies,
                          category: .movie,
                          parameters: ["release_date.lte": formatter.string(from: currentDate),
                                       "sort_by": "popularity.desc"]),
                MWSection(name: "Series and shows".localized(),
                          url: URLPaths.discoverTVs,
                          category: .tv,
                          parameters: ["first_air_date.lte": formatter.string(from: currentDate),
                                       "sort_by": "popularity.desc"]),
                MWSection(name: "Animated movies".localized(),
                          url: URLPaths.discoverMovies,
                          category: .movie,
                          parameters: ["release_date.lte": formatter.string(from: currentDate),
                                       "sort_by": "popularity.desc"],
                          genreIds: [16])]
    }()
    
    //MARK: - gui variables
    
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
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refreshTableView), for: .valueChanged)
        refresh.tintColor = UIColor(named: "accentColor")
        return refresh
    }()
    
    //MARK: - init
    
    override func initController() {
        super.initController()
        self.navigationItem.title = "Movie World"

        self.loadMovies()
        
        self.dispatchGroup.notify(queue: DispatchQueue.main) {
            self.view.addSubview(self.tableView)
            self.makeConstraints()
        }
    }
    
    //MARK: - constraints
    
    private func makeConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - functions

    @objc private func refreshTableView() {
        self.tableView.isHidden = true
        self.loadMovies()
        self.dispatchGroup.notify(queue: DispatchQueue.main) {
            self.tableView.isHidden = false
        }
        self.refreshControl.endRefreshing()
    }
    
    @objc private func allButtonTapped(sender: UIButton) {
        let controller = MWMovieListViewController()
        controller.section = self.sections[sender.tag].copy() as? MWSection
        MWI.sh.push(controller)
    }
    
    private func loadMovies(into section: MWSection? = nil) {
        self.dispatchGroup.enter()
        
        if let section = section {
            let index = self.sections.firstIndex { $0.name == section.name } ?? -1
            switch section.category {
            case .movie:
                MWN.sh.request(
                    url: section.url,
                    queryParameters: section.requestParameters,
                    successHandler: { [weak self] (response: MWMovieRequestResult<MWMovie>) in
                        section.loadResults(from: response)
                        self?.tableView.reloadRows(at: [IndexPath(row: 0, section: index)],
                                                   with: .automatic)
                        self?.dispatchGroup.leave()
                }) { [weak self] error in
                    error.printInConsole()
                    self?.dispatchGroup.leave()
                }
            case .tv:
                MWN.sh.request(
                    url: section.url,
                    queryParameters: section.requestParameters,
                    successHandler: { [weak self] (response: MWMovieRequestResult<MWShow>) in
                        section.loadResults(from: response)
                        self?.tableView.reloadRows(at: [IndexPath(row: 0, section: index)],
                                                   with: .automatic)
                        self?.dispatchGroup.leave()
                }) { [weak self] error in
                    error.printInConsole()
                    self?.dispatchGroup.leave()
                }
            }
        } else {
            self.sections.forEach { self.loadMovies(into: $0) }
            self.dispatchGroup.leave()
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension MWMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.tableView.dequeueReusableHeaderFooterView(withIdentifier: MWTableViewHeader.reuseID)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let view = view as? MWTableViewHeader else { return }
        view.titleLabel.text = self.sections[section].name
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.sections[indexPath.section].movies.count != 0 {
            let cell = self.tableView
                .dequeueReusableCell(withIdentifier: MWCollectionTableViewCell.reuseID,
                                     for: indexPath)
                as? MWCollectionTableViewCell ?? MWCollectionTableViewCell()
            cell.movies = self.sections[indexPath.section].movies
            cell.collectionView.reloadData()
            return cell
        } else {
            let cell = self.tableView
                .dequeueReusableCell(withIdentifier: MWRetryTableViewCell.reuseID,
                                     for: indexPath)
                as? MWRetryTableViewCell ?? MWRetryTableViewCell()
            cell.retryTapped = { [weak self] in
                self?.loadMovies(into: self?.sections[indexPath.section])
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 237
    }
}
