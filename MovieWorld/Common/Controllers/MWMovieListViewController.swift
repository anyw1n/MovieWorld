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
    
    private let sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    private let collectionViewInsets = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    private let collectionViewHeight = 94
    var section: MWSection?
    var pagesLoaded: Int = 0
    private var totalPages: Int = 50
//    private var totalItems: Int = 1000
    private var isRequestBusy: Bool = false
    
    //MARK: - gui variables
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 100, height: 26)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = self.sectionInsets
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect(),
                                    collectionViewLayout: self.collectionViewFlowLayout)
        view.dataSource = self
        view.delegate = self
        view.register(MWTagCollectionViewCell.self,
                      forCellWithReuseIdentifier: MWTagCollectionViewCell.reuseID)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        view.allowsMultipleSelection = true
        view.contentInset = self.collectionViewInsets
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect(), style: .grouped)
        view.delegate = self
        view.dataSource = self
        view.register(MWMovieCardTableViewCell.self,
                      forCellReuseIdentifier: MWMovieCardTableViewCell.reuseID)
        view.separatorStyle = .none
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    //MARK: - init
    
    override func initController() {
        super.initController()
        
        self.navigationItem.title = section?.name
        self.view.addSubview(self.tableView)
        self.makeConstraints()
        
        if self.pagesLoaded == 0 {
            self.loadMovies()
        }
    }
    
    //MARK: - constraints
    
    private func makeConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - functions
    
    private func loadMovies() {
        guard !self.isRequestBusy, self.pagesLoaded != self.totalPages else { return }
        self.isRequestBusy = true

        self.requestMovies(page: self.pagesLoaded + 1) { [weak self] (movies) in
            guard let self = self else { return }
            self.isRequestBusy = false
            self.section?.movies.append(contentsOf: movies)
            self.pagesLoaded += 1
            self.tableView.reloadData()
        }
    }
    
    private func requestMovies(page: Int, completion: @escaping ([MWMovie]) -> Void) {
        guard let section = self.section else { return }
        section.requestParameters["page"] = page
        MWN.sh.request(url: section.url,
                       queryParameters: section.requestParameters,
                       successHandler: { (response: [MWMovie]) in
                        completion(response)
        }) { (error) in
            error.printInConsole()
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MWMovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MWS.sh.genres[.movie]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView
            .dequeueReusableCell(withReuseIdentifier: MWTagCollectionViewCell.reuseID,
                                 for: indexPath)
            as? MWTagCollectionViewCell ?? MWTagCollectionViewCell()
        guard let genre = MWS.sh.genres[.movie]?[indexPath.row] else { return cell }
        cell.titleLabel.text = genre.name
        if self.section?.genreIds?.contains(genre.id) ?? false {
            cell.isSelected = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = self.section,
            let genre = MWS.sh.genres[.movie]?[indexPath.row] else { return }
        if section.genreIds != nil {
            section.genreIds!.insert(genre.id)
        } else {
            section.genreIds = [genre.id]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let genre = MWS.sh.genres[.movie]?[indexPath.row] else { return }
        self.section?.genreIds?.remove(genre.id)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension MWMovieListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.section?.movies.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView
            .dequeueReusableCell(withIdentifier: MWMovieCardTableViewCell.reuseID,
                                 for: indexPath)
            as? MWMovieCardTableViewCell ?? MWMovieCardTableViewCell()
        guard let movies = self.section?.movies else { return cell }
        cell.setup(movies[indexPath.row])

        if indexPath.row == movies.count - 5 {
            self.loadMovies()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? MWMovieCardTableViewCell)?.posterImageView.kf.cancelDownloadTask()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.collectionView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(self.collectionViewHeight)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
