//
//  MWConfiguration+CoreDataClass.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/12/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//
//

import Foundation
import CoreData

@objc(MWConfiguration)
public class MWConfiguration: NSManagedObject, Decodable {

    private enum CodingKeys: String, CodingKey {
        case images
    }

    private enum ImageCodingKeys: String, CodingKey {
        case baseUrl = "base_url", secureBaseUrl = "secure_base_url"
    }

    static let entityName = "MWConfiguration"

    required convenience public init(from decoder: Decoder) throws {
        self.init(context: CoreDataManager.sh.persistentContainer.viewContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        let imageContainer =
            try container.nestedContainer(keyedBy: ImageCodingKeys.self, forKey: .images)
        self.baseUrl = (try? imageContainer.decode(String.self, forKey: .baseUrl))
        self.secureBaseUrl = (try? imageContainer.decode(String.self, forKey: .secureBaseUrl))
    }
}
