//
//  MWRoundedButton.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/25/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWRoundedButton: UIButton {

    private let titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)

    init(text: String = "", image: UIImage? = nil) {
        super.init(frame: CGRect.zero)
        self.setTitle(text, for: UIControl.State())
        self.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.setImage(image, for: UIControl.State())
        self.backgroundColor = UIColor(named: "accentColor")
        self.layer.cornerRadius = 5
        self.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        self.titleEdgeInsets = self.titleInsets
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
