//
//  MWGenre+CoreDataProperties.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/12/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//
//

import Foundation
import CoreData

extension MWGenre {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MWGenre> {
        return NSFetchRequest<MWGenre>(entityName: "MWGenre")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var category: String?
}
