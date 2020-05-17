//
//  MWCastViewController.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/22/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWCastViewController: MWViewController {

    private enum Crew: String, CaseIterable {

        static var credits: MWCredits?

        case director, screenplay, producer

        func getCreators() -> [MWCreator] {
            return Crew.credits?.getCreators(job: self.rawValue.capitalizedFirstLetter()) ?? []
        }
    }

    // MARK: - variables

    var credits: MWCredits? {
        didSet {
            Crew.credits = self.credits
            self.credits?.cast.forEach { $0.requestDetails() }
        }
    }

    private let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)

    private var creators = Crew.allCases

    // MARK: - gui variables

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect(), style: .grouped)
        view.delegate = self
        view.dataSource = self
        view.register(MWActorTableViewCell.self,
                      forCellReuseIdentifier: MWActorTableViewCell.reuseId)
        view.register(MWTitleTableViewHeader.self,
                      forHeaderFooterViewReuseIdentifier: MWTitleTableViewHeader.reuseId)
        view.register(MWCreatorTableViewCell.self,
                      forCellReuseIdentifier: MWCreatorTableViewCell.reuseId)
        view.separatorStyle = .none
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.contentInset = self.contentInsets
        view.backgroundColor = .white
        return view
    }()

    // MARK: - init

    override func initController() {
        super.initController()

        self.navigationItem.title = "Cast".localized()

        self.view.insertSubview(self.tableView, at: 0)
        self.makeConstraints()
    }

    // MARK: - constraints

    private func makeConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate

extension MWCastViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView
            .dequeueReusableHeaderFooterView(withIdentifier: MWTitleTableViewHeader.reuseId)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView,
                   willDisplayHeaderView view: UIView,
                   forSection section: Int) {
        guard let view = view as? MWTitleTableViewHeader else { return }
        let creators = self.creators[section - 1], creatorsCount = creators.getCreators().count

        view.titleLabel.text = "\(creators.rawValue)\( creatorsCount > 1 ? "s" : "")".localized()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return CGFloat.leastNonzeroMagnitude
        default:
            return MWTitleTableViewHeader.height
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 0, let actor = self.credits?.cast[indexPath.row] else { return }
        let controller = MWActorDetailsViewController()
        controller.actor = actor
        MWI.sh.push(controller)
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        self.credits?.cast[indexPath.row].detailsLoaded = nil
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cast = self.credits?.cast else { return 100 }

        switch indexPath.section {
        case 0:
            if indexPath.row == cast.count - 1 { return MWActorTableViewCell.height }
            return MWActorTableViewCell.height + 3
        default:
            let creators = self.creators[indexPath.section - 1].getCreators()
            if indexPath.row == creators.count - 1 { return MWCreatorTableViewCell.height }
            return MWCreatorTableViewCell.height + 16
        }
    }
}

// MARK: - UITableViewDataSource

extension MWCastViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let credits = self.credits else { return 0 }
        switch section {
        case 0:
            return credits.cast.count
        default:
            return self.creators[section - 1].getCreators().count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let credits = self.credits else { return UITableViewCell() }
        switch indexPath.section {
        case 0:
            let cell = tableView
                .dequeueReusableCell(withIdentifier: MWActorTableViewCell.reuseId, for: indexPath)

            (cell as? MWActorTableViewCell)?.setup(actor: credits.cast[indexPath.row])
            cell.setNeedsUpdateConstraints()
            return cell
        default:
            let cell = tableView
                .dequeueReusableCell(withIdentifier: MWCreatorTableViewCell.reuseId, for: indexPath)

            (cell as? MWCreatorTableViewCell)?.setup(
                creator: self.creators[indexPath.section - 1].getCreators()[indexPath.row])
            cell.setNeedsUpdateConstraints()
            return cell
        }
    }
}
