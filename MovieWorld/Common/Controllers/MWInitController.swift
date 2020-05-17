//
//  MWInitController.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/7/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWInitController: MWViewController {

    // MARK: - variables

    private let stackViewInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)

    private let spinnerInsets = UIEdgeInsets(top: 0, left: 0, bottom: 76, right: 0)
    private let spinnerSize = CGSize(width: 35, height: 35)

    private let dispatchGroup = DispatchGroup()

    // MARK: - gui variables

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Movie World"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = UIColor(named: "textColor")
        return label
    }()

    private lazy var imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "launchImage"))
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            spinner.style = .large
        } else {
            spinner.style = .whiteLarge
        }
        spinner.color = UIColor(named: "accentColor")
        return spinner
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.textLabel, self.imageView])
        view.spacing = 42
        view.axis = .vertical
        view.alignment = .center
        return view
    }()

    // MARK: - init

    override func initController() {
        super.initController()
        self.view.addSubview(self.stackView)
        self.view.addSubview(self.spinner)

        self.makeConstraints()

        self.spinner.startAnimating()

        for value in MWS.Values.allCases {
            self.dispatchGroup.enter()
            value.load { [weak self] in
                self?.dispatchGroup.leave()
            }
        }

        self.dispatchGroup.notify(queue: DispatchQueue.main) {
            MWI.sh.window?.rootViewController = MWI.sh.tabBarController
        }
    }

    // MARK: - constraints

    private func makeConstraints() {
        self.stackView.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualToSuperview()
            make.left.right.equalToSuperview().inset(self.stackViewInsets)
            make.centerY.equalToSuperview()
        }
        self.spinner.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(self.stackView)
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.bottom.equalToSuperview().inset(self.spinnerInsets)
            make.centerX.equalToSuperview()
            make.size.equalTo(self.spinnerSize)
        }
    }
}
