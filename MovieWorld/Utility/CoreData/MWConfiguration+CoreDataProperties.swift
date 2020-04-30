//
//  MWConfiguration+CoreDataProperties.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/13/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//
//

import Foundation
import CoreData

extension MWConfiguration {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MWConfiguration> {
        return NSFetchRequest<MWConfiguration>(entityName: "MWConfiguration")
    }

    @NSManaged public var baseURL: String?
    @NSManaged public var secureBaseURL: String?
    @NSManaged public var id: Int64
}
