//
//  MWViewController.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/15/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit
import SnapKit

class MWViewController: UIViewController {

    //MARK: - variables
    
    let cardView = MWCardView()
    
    //MARK: - functions
    
    private func makeConstraints() {
        self.cardView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
    }
    
    //MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view.addSubview(cardView)
        self.makeConstraints()
    }


}

