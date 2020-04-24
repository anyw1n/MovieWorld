//
//  MWActorTableViewCell.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/22/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWActorTableViewCell: UITableViewCell {
    
    // MARK: - variables
    
    static let reuseId = "actorTableViewCell"
    static let height: CGFloat = 90
    
    // MARK: - gui variables
    
    private let layout: MWActorCardView = MWActorCardView()
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.contentView.addSubview(self.layout)
        self.makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - constraints
    
    private func makeConstraints() {
        self.layout.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.layout.makeConstraints()
    }
    
    // MARK: - functions
    
    func setup(actor: MWActor) {
        self.layout.setup(actor: actor)
    }
}
