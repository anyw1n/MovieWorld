//
//  MWCategoryViewController.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/22/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWCategoryViewController: MWViewController {
    
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    var categories: [String] = Array(repeating: "Top 250", count: 25)

    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(MWTitleArrowCell.self, forCellReuseIdentifier: MWTitleArrowCell.reuseID)
        self.tableView.separatorStyle = .none
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
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
        let header = UIView()
        header.backgroundColor = .white
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: MWTitleArrowCell.reuseID,
                                                      for: indexPath)
            as? MWTitleArrowCell ?? MWTitleArrowCell()
        cell.titleLabel.text = self.categories[indexPath.section]
        return cell
    }
}
