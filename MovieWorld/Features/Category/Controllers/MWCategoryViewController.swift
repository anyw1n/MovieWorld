//
//  MWCategoryViewController.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/22/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWCategoryViewController: MWViewController {

    // MARK: - variables

    var categories: [String] = Array(repeating: "Top 250", count: 25)

    // MARK: - gui variables

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .grouped)
        view.delegate = self
        view.dataSource = self
        view.register(MWTitleArrowCell.self, forCellReuseIdentifier: MWTitleArrowCell.reuseId)
        view.separatorStyle = .none
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        return view
    }()

    // MARK: - init

    override func initController() {
        super.initController()
        self.navigationItem.title = "Category".localized()

        self.view.addSubview(self.tableView)
        self.makeConstraints()
    }

    // MARK: - constraints

    private func makeConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

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
        let cell = tableView.dequeueReusableCell(withIdentifier: MWTitleArrowCell.reuseId,
                                                 for: indexPath)
        (cell as? MWTitleArrowCell)?.titleLabel.text = self.categories[indexPath.section]
        cell.setNeedsUpdateConstraints()
        return cell
    }
}
