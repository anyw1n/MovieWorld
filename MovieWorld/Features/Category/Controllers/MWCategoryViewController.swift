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

    private var categories: [(category: MWCategory, genres: [MWGenre])] {
        var categories: [(category: MWCategory, genres: [MWGenre])] = []
        MWCategory.allCases.forEach {
            categories.append(($0, MWS.sh.genres[$0] ?? []))
        }
        return categories
    }

    // MARK: - gui variables

    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        self.categories.enumerated().forEach {
            control.insertSegment(withTitle: $1.category.rawValue.localized(),
                                  at: $0,
                                  animated: false)
        }
        control.selectedSegmentIndex = 0
        control.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8823529412, alpha: 1)
        control.tintColor = .white
        control.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        control.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        control.addTarget(self, action: #selector(self.segmentChanged), for: .valueChanged)
        return control
    }()

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

    private lazy var retryView: MWRetryView = {
        let view = MWRetryView()
        view.delegate = self
        return view
    }()

    // MARK: - init

    override func initController() {
        super.initController()
        self.navigationItem.title = "Category".localized()

        self.view.addSubview(self.segmentedControl)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.retryView)
        self.makeConstraints()
    }

    // MARK: - constraints

    private func makeConstraints() {
        self.segmentedControl.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.segmentedControl.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        self.retryView.snp.makeConstraints { (make) in
            make.top.equalTo(self.segmentedControl.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        self.retryView.makeConstraints()
    }

    // MARK: - actions

    @objc private func segmentChanged() {
        self.tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MWCategoryViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if self.categories[self.segmentedControl.selectedSegmentIndex].genres.isEmpty {
            self.retryView.show()
        } else {
            self.retryView.hide()
        }
        return self.categories[self.segmentedControl.selectedSegmentIndex].genres.count
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
        let genre =
            self.categories[self.segmentedControl.selectedSegmentIndex].genres[indexPath.section]
        (cell as? MWTitleArrowCell)?.titleLabel.text = genre.name
        cell.setNeedsUpdateConstraints()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let genre =
            self.categories[self.segmentedControl.selectedSegmentIndex].genres[indexPath.section]
        let category = self.categories[self.segmentedControl.selectedSegmentIndex].category
        let controller = MWMovieListViewController()
        controller.setup(section: MWSection(
            name: genre.name ?? "",
            url: category.discoverUrl,
            category: category,
            parameters: ["sort_by": "popularity.desc",
                         "release_date.lte": Date().formatted(dateFormat: MWN.sh.tmdbDateFormat)],
            genreIds: [genre.id]),
                         isHeaderEnabled: false)
        MWI.sh.push(controller)
    }
}

// MARK: - MWRetryViewDelegate

extension MWCategoryViewController: MWRetryViewDelegate {

    func retryButtonTapped() {
        self.tableView.reloadData()
    }

    func message() -> String? { "Nothing to show here..".localized() }
}
