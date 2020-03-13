//
//  MWStubTableViewCell.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/8/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWRefreshTableViewCell: UITableViewCell {
    
    //MARK: - variables
    
    static let reuseID = "refreshTableViewCell"
    var refreshTapped: (() -> Void)?

    //MARK: - gui variables
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "refreshIcon"), for: .init())
        button.tintColor = UIColor(named: "accentColor")
        button.setTitle("Refresh", for: .init())
        button.setTitleColor(UIColor(named: "textColor"), for: .init())
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(self.refreshButtonTapped), for: .touchUpInside)
        return button
    }()

    //MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .white
        self.selectionStyle = .none
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - constraints
    
    private func makeConstraints() {
        self.refreshButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - functions
    
    private func addSubviews() {
        self.contentView.addSubview(self.refreshButton)
        self.makeConstraints()
    }
    
    @objc private func refreshButtonTapped() {
        self.refreshTapped?()
    }
}
