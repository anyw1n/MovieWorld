//
//  MWTableViewCell.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/1/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWCollectionTableViewCell: UITableViewCell {

    // MARK: - variables

    static let reuseId = "MWCollectionTableViewCell"

    private var section: MWSection?

    private var retryTapped: (() -> Void)?
    private var error: String?

    // MARK: - gui variables

    private lazy var collectionView: MWCollectionViewWithHeader<Movieable,
        MWMovieCardCollectionViewCell> = {
            let view = MWCollectionViewWithHeader<Movieable, MWMovieCardCollectionViewCell>()
            view.titleLabel.font = .boldSystemFont(ofSize: 24)
            view.sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 7)
            view.maximumItems = 20
            view.delegate = self
            return view
    }()

    // MARK: - init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .white
        self.selectionStyle = .none
        self.contentView.addSubview(self.collectionView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - constraints

    override func updateConstraints() {
        self.collectionView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.collectionView.makeConstraints()
        super.updateConstraints()
    }

    // MARK: - functions

    func setup(section: MWSection,
               retryButtonTapped: (() -> Void)?) {
        self.section = section
        self.retryTapped = retryButtonTapped
        self.error = section.message
        self.collectionView.setup(title: section.name,
                                  items: section.movies)
    }
}

// MARK: - MWCollectionViewWithHeaderDelegate

extension MWCollectionTableViewCell: MWCollectionViewWithHeaderDelegate {

    func cellTapped(indexPath: IndexPath) {
        let controller = MWMovieDetailsViewController()
        controller.movie = self.section?.movies[indexPath.row]
        MWI.sh.push(controller)
    }

    func allButtonTapped() {
        let controller = MWMovieListViewController()
        controller.setup(section: self.section?.copy())
        MWI.sh.push(controller)
    }

    func retryButtonTapped() {
        self.retryTapped?()
    }

    func message() -> String? {
        return self.error
    }
}
