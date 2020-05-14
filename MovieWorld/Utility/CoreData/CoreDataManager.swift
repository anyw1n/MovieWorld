//
//  CoreDataManager.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/12/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import CoreData
import Foundation

typealias CDM = CoreDataManager

class CoreDataManager {

    // MARK: - variables

    static let sh = CoreDataManager()

    // MARK: - Core Data stack

    private(set) lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
        })
        container.viewContext.mergePolicy =
            NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        return container
    }()

    // MARK: - init

    private init() {}

    // MARK: - functions

    func fetchRequest<T: NSFetchRequestResult>(entityName: String,
                                               keysForSort: [String]? = nil,
                                               predicate: NSPredicate? = nil) -> NSFetchRequest<T> {
        let request = NSFetchRequest<T>(entityName: entityName)
        request.sortDescriptors = []
        keysForSort?.forEach { key in
            request.sortDescriptors?.append(NSSortDescriptor(key: key, ascending: true))
        }
        request.predicate = predicate
        return request
    }

    func loadData<T: NSFetchRequestResult>(entityName: String,
                                           keysForSort: [String]? = nil,
                                           predicate: NSPredicate? = nil) -> [T]? {
        let fetchRequest: NSFetchRequest<T> =
            self.fetchRequest(entityName: entityName,
                              keysForSort: keysForSort,
                              predicate: predicate)
        var data: [T]?
        do {
            data = try self.persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        return data
    }

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = self.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
