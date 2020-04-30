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

    // MARK: - init

    override func viewDidLoad() {
        super.viewDidLoad()

        self._initController()
        self.initController()
    }

    private func _initController() {
        self.view.backgroundColor = .white
        self.navigationItem.backBarButtonItem =
            UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    func initController() { }
}
