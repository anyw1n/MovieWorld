//
//  MWSearchViewController.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/22/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWSearchViewController: MWViewController {
    
    //MARK: - init
    
    override func initController() {
        super.initController()
        
        self.navigationItem.title = "Search".localized()
    }
}
