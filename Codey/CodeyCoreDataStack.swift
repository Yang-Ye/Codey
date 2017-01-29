//
//  CodeyCoreDataStack.swift
//  Codey
//
//  Created by Yang Ye on 11/14/16.
//  Copyright © 2016 YY. All rights reserved.
//

import Foundation
import CoreData

class CodeyCoreDataStack {
    let mainContext: NSManagedObjectContext!
    let model: NSManagedObjectModel!

    init?() {
        guard let modelURL = Bundle.main.url(forResource: "CodeyModel", withExtension: "momd") else {
            return nil
        }
        guard let objectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            return nil
        }
        model = objectModel
        let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.persistentStoreCoordinator = psc
        mainContext.parent = privateContext

        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex-1]
        let storeURL = docURL.appendingPathComponent("CodeyModel.sqlite")
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
        } catch {
            return nil
        }
    }

    func fetchProblem(predicate: NSPredicate) -> [Problem]? {
        let fetchRequest = NSFetchRequest<Problem>(entityName: "Problem")
        fetchRequest.predicate = predicate
        do {
            let fetchedProblem = try mainContext.fetch(fetchRequest)
            return fetchedProblem
        } catch {
            return nil
        }
    }

    func fetchAllProblems() -> [Problem]?{
        do {
            let fetchedProblems = try mainContext.fetch(NSFetchRequest<Problem>(entityName: "Problem"))
            return fetchedProblems
        } catch {
            return nil
        }
    }

    func makeNewProblem(name: String, value: Dictionary<String, NSObject>) -> Problem {
        let newProblem = NSEntityDescription.insertNewObject(forEntityName: "Problem", into: mainContext) as! Problem
        newProblem.name = name
        newProblem.hardness = value["hardness"] as! Int
        newProblem.tags = value["tags"] as! [String]
        newProblem.company = value["company"] as! [String]
        newProblem.isSolved = false
        newProblem.isStared = false
        newProblem.isHot = (value["isHot"] as? Bool) ?? false
        newProblem.searchName = name.lowercased()
        newProblem.order = value["order"] as! Int
        return newProblem
    }

    func save() {
        do {
            try mainContext.save()
            do {
                try mainContext.parent?.save()
            } catch {
                return
            }
        } catch {
            return
        }
    }
}
