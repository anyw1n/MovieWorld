//
//  MWCastViewController.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/22/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWCastViewController: MWViewController {

    // MARK: - variables
    
    var credits: MWCredits?
    
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
        return view
    }()
    
    // MARK: - init
    
    override func initController() {
        super.initController()
        
        self.navigationItem.title = "Cast".localized()
            
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

extension MWCastViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let credits = self.credits else { return 0 }
        switch section {
        case 0:
            return credits.cast.count
        default:
            return credits.creators[section - 1].creators.count
        }
    }
    
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
        guard let view = view as? MWTitleTableViewHeader, let credits = self.credits else { return }
        view.titleLabel.text = credits.creators[section - 1].name
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return CGFloat.leastNonzeroMagnitude
        default:
            return 62
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let credits = self.credits else { return UITableViewCell() }
        switch indexPath.section {
        case 0:
            let cell = tableView
                .dequeueReusableCell(withIdentifier: MWActorTableViewCell.reuseId, for: indexPath)
                as? MWActorTableViewCell ?? MWActorTableViewCell()
            
            cell.setup(actor: credits.cast[indexPath.row])
            return cell
        default:
            let cell = tableView
                .dequeueReusableCell(withIdentifier: MWCreatorTableViewCell.reuseId, for: indexPath)
            as? MWCreatorTableViewCell ?? MWCreatorTableViewCell()
            
            cell.setup(creator: credits.creators[indexPath.section - 1].creators[indexPath.row])
            return cell
        }
    }
}
