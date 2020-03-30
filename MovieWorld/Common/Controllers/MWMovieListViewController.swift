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
    
    private let collectionViewInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    private let collectionViewHeight: CGFloat = 92
    var section: MWSection?
    private var isRequestBusy: Bool = false
    
    //MARK: - gui variables
    
    private lazy var tagCollectionViewLayout: MWTagCollectionViewLayout = {
        let layout = MWTagCollectionViewLayout()
        layout.delegate = self
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect(),
                                    collectionViewLayout: self.tagCollectionViewLayout)
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
        view.refreshControl = self.refreshControl
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refreshTableView), for: .valueChanged)
        refresh.tintColor = UIColor(named: "accentColor")
        return refresh
    }()
    
    //MARK: - init
    
    override func initController() {
        super.initController()
        
        self.navigationItem.title = section?.name
        self.view.addSubview(self.tableView)
        self.makeConstraints()
        
        if self.section?.pagesLoaded == 0 {
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
        guard !self.isRequestBusy,
            self.section?.pagesLoaded != self.section?.totalPages else { return }
        self.isRequestBusy = true
        
        self.requestMovies(page: (self.section?.pagesLoaded ?? 0) + 1) { [weak self] (response) in
            guard let self = self else { return }
            self.isRequestBusy = false
            self.section?.loadResults(from: response)
            self.tableView.reloadData()
        }
    }
    
    private func requestMovies(page: Int, completion: @escaping (MWMovieRequestResult) -> Void) {
        guard let section = self.section else { return }
        section.requestParameters["page"] = page
        MWN.sh.request(url: section.url,
                       queryParameters: section.requestParameters,
                       successHandler: { (response: MWMovieRequestResult) in
                        completion(response)
        }) { (error) in
            error.printInConsole()
        }
    }
    
    @objc private func refreshTableView() {
        self.section?.clearResults()
        self.tableView.reloadData()
        self.loadMovies()
        self.refreshControl.endRefreshing()
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
        
        cell.button.setTitle(genre.name, for: .init())
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
        self.refreshTableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let genre = MWS.sh.genres[.movie]?[indexPath.row] else { return }
        self.section?.genreIds?.remove(genre.id)
        self.refreshTableView()
    }
}

//MARK: - MWTagCollectionViewLayoutDelegate

extension MWMovieListViewController: MWTagCollectionViewLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, widthForTagAtIndexPath indexPath: IndexPath) -> CGFloat {
        let genreName = MWS.sh.genres[.movie]?[indexPath.row].name as NSString? ?? ""
        let genreNameWidth =
            genreName.size(withAttributes: [.font: UIFont.systemFont(ofSize: 13)]).width
        let inset: CGFloat = 12
        return genreNameWidth + inset * 2
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
        return self.collectionViewHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
