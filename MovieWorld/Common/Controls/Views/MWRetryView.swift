//
//  MWRetryView.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 5/14/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWRetryView: UIView {

    // MARK: - variables

    weak var delegate: MWRetryViewDelegate?

    private let buttonSize = CGSize(width: 150, height: 40)
    private let insets = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)

    // MARK: - gui variables

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "textColor")
        label.alpha = 0.5
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var retryButton: UIButton = {
        let button = MWRoundedButton(text: "Retry".localized(),
                                     image: UIImage(named: "refreshIcon"))
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(self.retryButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .white
        self.isHidden = true
        self.alpha = 0
        self.addSubview(self.messageLabel)
        self.addSubview(self.retryButton)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - constraints

    func makeConstraints() {
        self.messageLabel.snp.updateConstraints { (make) in
            make.top.equalToSuperview().inset(self.insets)
            make.left.greaterThanOrEqualToSuperview().inset(self.insets)
            make.right.lessThanOrEqualToSuperview().inset(self.insets)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualTo(self.retryButton.snp.top)
        }
        self.retryButton.snp.updateConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(self.buttonSize)
            make.top.left.greaterThanOrEqualToSuperview()
            make.right.bottom.lessThanOrEqualToSuperview()
        }
    }

    // MARK: - helpers

    func show(retryButtonEnabled: Bool = true) {
        self.retryButton.isHidden = !retryButtonEnabled
        self.superview?.bringSubviewToFront(self)
        self.messageLabel.text = self.delegate?.message()
        self.isHidden = false
        UIView.animate(withDuration: 0.3) { self.alpha = 1 }
    }

    func hide() {
        UIView.animate(withDuration: 0.3,
                       animations: { self.alpha = 0 }) { _ in self.isHidden = true }
    }

    // MARK: - actions

    @objc private func retryButtonTapped() {
        self.delegate?.retryButtonTapped()
    }
}

// MARK: - MWRetryViewDelegate

protocol MWRetryViewDelegate: AnyObject {

    func retryButtonTapped()
    func message() -> String?
}

extension MWRetryViewDelegate {

    func retryButtonTapped() { }
    func message() -> String? { "Oops, something went wrong(".localized() }
}
