//
//  MWCategoryViewController.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/22/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWCategoryViewController: MWViewController {
    
    let tableView = UITableView()
    private let cellID = "titleArrowCell"
    private let headerID = "spaceHeaderView"
    var categories: [String] = Array(repeating: "Top 250", count: 25)

    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(MWTitleArrowCell.self, forCellReuseIdentifier: self.cellID)
        self.tableView.register(UITableViewHeaderFooterView.self,
                                forHeaderFooterViewReuseIdentifier: self.headerID)
        self.tableView.separatorStyle = .none
        self.view.addSubview(self.tableView)
    }
    
    private func makeConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func initController() {
        self.navigationItem.title = "Category"
        
        self.setupTableView()
        self.makeConstraints()
    }
}

extension MWCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerID)
        let background = UIView()
        background.backgroundColor = .white
        header?.backgroundView = background
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
            as? MWTitleArrowCell ?? MWTitleArrowCell()
        cell.titleLabel.text = self.categories[indexPath.section]
        return cell
    }
}
