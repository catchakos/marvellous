//
//  CoreDataStackFake.swift
//  Marvellous
//
//  Created by Maria Pons Sanchez on 28/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import Foundation
import CoreData
@testable import Marvellous

class CoreDataStackFake {
    var managedObjectContext : NSManagedObjectContext!
    
    init() {
        managedObjectContext = setUpInMemoryManagedObjectContext()
        _ = createFakeHero()
    }
    
    func tearDown() {
        managedObjectContext = nil
    }
    
    func save() {
        do {
            try managedObjectContext.save()
        } catch {
            print("could not save fake pattern due to error: \(error)")
        }
    }
    
    func createFakeHero() -> Hero {
        let hero : Hero = NSEntityDescription.insertNewObject(forEntityName: "Hero", into: managedObjectContext) as! Hero
        hero.name = "FakeHero"
        hero.desc = "FakeDescription"
        hero.identifier = 100
        hero.thumbnailUrl = "http://url"
        return hero
    }

    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }

}
