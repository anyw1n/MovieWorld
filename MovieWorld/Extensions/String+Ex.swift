//
//  String+Ex.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/1/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

extension String {

    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }

    func localized(args: CVarArg...) -> String {
        return String(format: self.localized(), arguments: args)
    }

    func capitalizedFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.dropFirst()
    }
}
