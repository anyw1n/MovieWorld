//
//  UIActivityIndicatorView+Ex.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/29/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Kingfisher

extension UIActivityIndicatorView: Indicator {

    public func startAnimatingView() { self.startAnimating() }

    public func stopAnimatingView() { self.stopAnimating() }

    public var view: IndicatorView { self }
}
