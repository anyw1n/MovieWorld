//
//  MWGenre+CoreDataClass.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/12/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//
//

import Foundation
import CoreData

@objc(MWGenre)
public class MWGenre: NSManagedObject, Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case id, name, category
    }
    
    static let entityName = "MWGenre"
    
    required convenience public init(from decoder: Decoder) throws {
        self.init(context: CoreDataManager.sh.persistentContainer.viewContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? container.decode(Int64.self, forKey: .id)) ?? -1
        self.name = (try? container.decode(String.self, forKey: .name))?.capitalizedFirstLetter()
    }
}
