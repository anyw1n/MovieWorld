//
//  MWFullscreenImageViewController.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/28/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit
import Kingfisher

class MWFullscreenImageViewController: MWViewController {

    // MARK: - variables

    override var modalPresentationStyle: UIModalPresentationStyle {
        get { .fullScreen }
        set { self.modalPresentationStyle = newValue }
    }

    override var modalTransitionStyle: UIModalTransitionStyle {
        get { .crossDissolve }
        set { self.modalTransitionStyle = newValue }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .allButUpsideDown }

    override var prefersStatusBarHidden: Bool { true }

    // MARK: - gui variables

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(self.imageViewTapped)))
        view.isUserInteractionEnabled = true
        view.alpha = 0
        return view
    }()

    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            spinner.style = .large
        } else {
            spinner.style = .whiteLarge
        }
        spinner.color = .white
        return spinner
    }()

    // MARK: - init

    override func initController() {
        super.initController()

        self.view.backgroundColor = .black
        self.view.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.imageView.alpha = 1
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.imageView.kf.cancelDownloadTask()
    }

    // MARK: - functions

    func setup(TMDBPath: String) {
        self.loadTMDBImage(path: TMDBPath, size: .w1280)
    }

    func loadTMDBImage(path: String, size: Sizes) {
        guard let baseUrl = MWS.sh.configuration?.secureBaseUrl else {
            self.imageView.image = UIImage(named: "noImage")
            return
        }

        let url = URL(string: baseUrl + size.rawValue + path)
        let options: KingfisherOptionsInfo = [.scaleFactor(UIScreen.main.scale),
                                              .transition(.fade(0.3)),
                                              .cacheOriginalImage]

        self.imageView.kf.indicatorType = .custom(indicator: self.spinner)
        self.imageView.kf.setImage(with: url,
                                   options: options)
    }

    @objc private func imageViewTapped() {
        self.dismiss(animated: true)
    }
}
