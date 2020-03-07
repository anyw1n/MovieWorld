//
//  MWInitController.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/7/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWInitController: MWViewController {
    
    private let stackViewInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
    private let spinnerInsets = UIEdgeInsets(top: 0, left: 0, bottom: 76, right: 0)
    private let spinnerSize = CGSize(width: 35, height: 35)
    
    private let dispatchGroup = DispatchGroup()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Movie World"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "launchImage"))
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
    
    private func makeConstraints() {
        self.stackView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(self.stackViewInsets)
        }
        self.spinner.snp.makeConstraints { (make) in
            make.top.equalTo(self.stackView.snp.bottom).offset(140)
            make.bottom.equalToSuperview().inset(self.spinnerInsets)
            make.centerX.equalToSuperview()
            make.size.equalTo(self.spinnerSize)
        }
    }
    
    private func loadMovieGenres() {
        self.dispatchGroup.enter()
        
        MWN.sh.request(url: URLPaths.movieGenres,
                       successHandler:
            { [weak self] (response: [String: Any]) in
                guard let genres = response["genres"] as? [[String: Any]] else { return }
                genres.forEach { (genre) in
                    guard let id = genre["id"] as? Int,
                        let name = genre["name"] as? String else { return }
                    Genres.movie[id] = name
                }
                self?.dispatchGroup.leave()
            },
                       errorHandler: { [weak self]  (error) in
                        error.printInConsole()
                        self?.dispatchGroup.leave()
        })
    }
    
    private func loadTVGenres() {
        self.dispatchGroup.enter()
        
        MWN.sh.request(url: URLPaths.tvGenres,
                       successHandler:
            { [weak self] (response: [String: Any]) in
                guard let genres = response["genres"] as? [[String: Any]] else { return }
                genres.forEach { (genre) in
                    guard let id = genre["id"] as? Int,
                        let name = genre["name"] as? String else { return }
                    Genres.tv[id] = name
                }
                self?.dispatchGroup.leave()
            },
                       errorHandler: { [weak self]  (error) in
                        error.printInConsole()
                        self?.dispatchGroup.leave()
        })
    }
    
    override func initController() {
        self.view.addSubview(self.stackView)
        self.view.addSubview(self.spinner)
        
        self.makeConstraints()
        
        self.spinner.startAnimating()
        
        self.loadMovieGenres()
        self.loadTVGenres()
        
        self.dispatchGroup.notify(queue: DispatchQueue.main) {
            MWI.sh.window?.rootViewController = MWI.sh.tabBarController
        }
    }
}
