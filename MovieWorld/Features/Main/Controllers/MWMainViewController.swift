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
        ["New": [MWMovie(title: "GreenBook", description: "2018, Comedy"),
                 MWMovie(title: "GreenBook", description: "2018, Comedy"),
                 MWMovie(title: "GreenBook", description: "2018, Comedy"),
                 MWMovie(title: "GreenBook", description: "2018, Comedy"),
                 MWMovie(title: "GreenBook", description: "2018, Comedy")],
         "Movies": [MWMovie(title: "GreenBook", description: "2018, Comedy"),
                    MWMovie(title: "GreenBook", description: "2018, Comedy"),
                    MWMovie(title: "GreenBook", description: "2018, Comedy"),
                    MWMovie(title: "GreenBook", description: "2018, Comedy"),
                    MWMovie(title: "GreenBook", description: "2018, Comedy")],
         "Series and shows": [MWMovie(title: "GreenBook", description: "2018, Comedy"),
                              MWMovie(title: "GreenBook", description: "2018, Comedy"),
                              MWMovie(title: "GreenBook", description: "2018, Comedy"),
                              MWMovie(title: "GreenBook", description: "2018, Comedy"),
                              MWMovie(title: "GreenBook", description: "2018, Comedy")],
         "Animated movies": [MWMovie(title: "GreenBook", description: "2018, Comedy"),
                             MWMovie(title: "GreenBook", description: "2018, Comedy"),
                             MWMovie(title: "GreenBook", description: "2018, Comedy"),
                             MWMovie(title: "GreenBook", description: "2018, Comedy"),
                             MWMovie(title: "GreenBook", description: "2018, Comedy")]]
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .grouped)
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "fff")
        view.register(MWTableViewHeader.self,
                                forHeaderFooterViewReuseIdentifier: MWTableViewHeader.reuseID)
        view.separatorStyle = .none
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
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "fff", for: indexPath)
        cell.textLabel?.text = "dlkgkldfgkldg"
        return cell
    }
    
    
}
