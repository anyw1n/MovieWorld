//
//  Date+Ex.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 5/5/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

extension Date {

    func formatted(dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
}
