//
//  MWMainViewController.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/22/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWMainViewController: MWViewController {
    
    private let movies: [String: [MWMovie]] =
        ["New": [MWMovie(title: "GreenBook11", description: "2018, Comedy"),
                 MWMovie(title: "GreenBook12", description: "2018, Comedy"),
                 MWMovie(title: "GreenBook13", description: "2018, Comedy"),
                 MWMovie(title: "GreenBook14", description: "2018, Comedy"),
                 MWMovie(title: "GreenBook15", description: "2018, Comedy")],
         "Movies": [MWMovie(title: "GreenBook21", description: "2018, Comedy"),
                    MWMovie(title: "GreenBook22", description: "2018, Comedy"),
                    MWMovie(title: "GreenBook23", description: "2018, Comedy"),
                    MWMovie(title: "GreenBook24", description: "2018, Comedy"),
                    MWMovie(title: "GreenBook25", description: "2018, Comedy")],
         "Series and shows": [MWMovie(title: "GreenBook31", description: "2018, Comedy"),
                              MWMovie(title: "GreenBook32", description: "2018, Comedy"),
                              MWMovie(title: "GreenBook33", description: "2018, Comedy"),
                              MWMovie(title: "GreenBook34", description: "2018, Comedy"),
                              MWMovie(title: "GreenBook35", description: "2018, Comedy")],
         "Animated movies": [MWMovie(title: "GreenBook41", description: "2018, Comedy"),
                             MWMovie(title: "GreenBook42", description: "2018, Comedy"),
                             MWMovie(title: "GreenBook43", description: "2018, Comedy"),
                             MWMovie(title: "GreenBook44", description: "2018, Comedy"),
                             MWMovie(title: "GreenBook45", description: "2018, Comedy")]]
    
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
    
    private func makeConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func initController() {
        self.navigationItem.title = "Season"
        
        self.view.addSubview(self.tableView)
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
