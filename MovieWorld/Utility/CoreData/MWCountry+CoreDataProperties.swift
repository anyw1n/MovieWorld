//
//  MWCountry+CoreDataProperties.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/2/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//
//

import Foundation
import CoreData

extension MWCountry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MWCountry> {
        return NSFetchRequest<MWCountry>(entityName: "MWCountry")
    }

    @NSManaged public var isoCode: String?
    @NSManaged public var name: String?

}
