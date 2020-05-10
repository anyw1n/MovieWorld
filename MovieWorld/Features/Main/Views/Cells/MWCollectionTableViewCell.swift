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

    // MARK: - gui variables

    private lazy var collectionView: MWCollectionViewWithHeader<Movieable,
        MWMovieCardCollectionViewCell> = {
            let view = MWCollectionViewWithHeader<Movieable, MWMovieCardCollectionViewCell>()
            view.titleLabel.font = .boldSystemFont(ofSize: 24)
            view.sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 7)
            view.maximumItems = 20
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

    func setup(section: MWSection, retryButtonTapped: (() -> Void)?) {
        self.collectionView.setup(title: section.name,
                                  items: section.movies,
                                  itemSpacing: 8,
                                  cellTapped: { (indexPath) in
                                    let controller = MWMovieDetailsViewController()
                                    controller.movie = section.movies[indexPath.row]
                                    MWI.sh.push(controller)
        }, allButtonTapped: {
            let controller = MWMovieListViewController()
            controller.section = section.copy()
            MWI.sh.push(controller)
        }, retryButtonTapped: retryButtonTapped)
    }
}
