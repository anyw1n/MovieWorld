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
        case baseURL = "base_url", secureBaseURL = "secure_base_url"
    }

    static let entityName = "MWConfiguration"

    required convenience public init(from decoder: Decoder) throws {
        self.init(context: CoreDataManager.sh.persistentContainer.viewContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.baseURL = (try? container.decode(String.self, forKey: .baseURL))
        self.secureBaseURL = (try? container.decode(String.self, forKey: .secureBaseURL))
    }
}
