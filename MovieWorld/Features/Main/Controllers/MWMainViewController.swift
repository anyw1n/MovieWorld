//
//  MWMainViewController.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/22/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWMainViewController: MWViewController {
    
    private var movies: [String: [MWMovie]] = [:]
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect(), style: .grouped)
        view.delegate = self
        view.dataSource = self
        view.register(MWCollectionTableViewCell.self, forCellReuseIdentifier: MWCollectionTableViewCell.reuseID)
        view.register(MWTableViewHeader.self,
                                forHeaderFooterViewReuseIdentifier: MWTableViewHeader.reuseID)
        view.separatorStyle = .none
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refreshTableView), for: .valueChanged)
        return refresh
    }()
    
    @objc private func refreshTableView() {
        print("reload")
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    private func makeConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func getMovies() {
        MWN.sh.request(typeOfResult: [String: Any].self, url: "/movie/popular",
                       successHandler: { results in
            guard let movies = results["results"] as? [[String : Any]] else { return }
            self.movies["Popular"] = []
            movies.forEach { (movie) in
                if let id = movie["id"] {
                    //self.movies["Popular"]?.append(MWMovie.parse(movieId: id))
                }
            }
            self.tableView.reloadData()
        },
                       errorHandler: { errorType in })
    }
    
    override func initController() {
        self.navigationItem.title = "Season"
        

        self.getMovies()
        self.view.addSubview(self.tableView)
        self.tableView.addSubview(self.refreshControl)
        self.makeConstraints()
    }
}

extension MWMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.tableView.dequeueReusableHeaderFooterView(withIdentifier: MWTableViewHeader.reuseID)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let view = view as? MWTableViewHeader else { return }
        view.titleLabel.text = Array(self.movies.keys)[section]
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
        let cell = self.tableView
            .dequeueReusableCell(withIdentifier: MWCollectionTableViewCell.reuseID, for: indexPath)
            as? MWCollectionTableViewCell ?? MWCollectionTableViewCell()
        cell.movies = Array(self.movies.values)[indexPath.section]
        cell.collectionView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 237
    }
}
