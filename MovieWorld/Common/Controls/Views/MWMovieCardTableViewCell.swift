//
//  MWMovieCardTableViewCell.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/16/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWMovieCardTableViewCell: UITableViewCell {
    
    // MARK: - variables
    
    static let reuseId = "movieCardTableViewCell"
    
    // MARK: - gui variables
    
    let layout: MWMovieCardView = MWMovieCardView()

    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .white
        self.selectionStyle = .none
        self.contentView.addSubview(self.layout)
        self.makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - constraints
    
    override func updateConstraints() {
        self.makeConstraints()
        super.updateConstraints()
    }
    
    private func makeConstraints() {
        self.layout.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.layout.makeConstraints()
    }
}
