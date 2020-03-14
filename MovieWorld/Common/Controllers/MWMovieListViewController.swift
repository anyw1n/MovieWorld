//
//  MWMovieListViewController.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/14/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWMovieListViewController: MWViewController {
    
    //MARK: - variables
    
    var section: MWSection?
    
    //MARK: - init
    
    override func initController() {
        super.initController()
        
        self.navigationItem.title = section?.name
    }
}
