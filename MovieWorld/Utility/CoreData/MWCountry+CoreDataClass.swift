//
//  MWCountry+CoreDataClass.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/2/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//
//

import Foundation
import CoreData

@objc(MWCountry)
public class MWCountry: NSManagedObject, Decodable {

    private enum CodingKeys: String, CodingKey {
        case isoCode = "iso_3166_1", englishName = "english_name", name = "name"
    }
    
    static let entityName = "MWCountry"
    
    required convenience public init(from decoder: Decoder) throws {
        self.init(context: CoreDataManager.sh.persistentContainer.viewContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isoCode = (try? container.decode(String.self, forKey: .isoCode))
        if container.contains(.name) {
            self.name = (try? container.decode(String.self, forKey: .name))
        } else {
            self.name = (try? container.decode(String.self, forKey: .englishName))
        }
    }
}
