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

    // MARK: - gui variables

    private lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            view.style = .large
        } else {
            view.style = .whiteLarge
        }
        view.color = UIColor(named: "accentColor")
        return view
    }()

    // MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self._initController()
        self.initController()
    }

    // MARK: - init

    func initController() { }

    private func _initController() {
        self.view.backgroundColor = .white
        self.navigationItem.backBarButtonItem =
            UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.view.addSubview(self.indicatorView)
        self.indicatorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

    // MARK: - functions

    func startSpinner() {
        self.view.bringSubviewToFront(self.indicatorView)
        self.indicatorView.startAnimating()
    }

    func stopSpinner() {
        self.indicatorView.stopAnimating()
    }
}
