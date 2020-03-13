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
    
    static let sh = CoreDataManager()
    
    private init() {}

    func fetchRequest<T: NSFetchRequestResult>(entityName: String,
                                               keysForSort: [String]? = nil,
                                               predicate: NSPredicate? = nil) -> NSFetchRequest<T> {
        let request = NSFetchRequest<T>(entityName: entityName)
        request.sortDescriptors = []
        keysForSort?.forEach() { key in
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
            data = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        return data
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.mergePolicy =
            NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
