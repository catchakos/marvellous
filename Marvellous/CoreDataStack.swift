//
//  CoreDataStack.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 27/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack: NSObject {
    
    static let sharedInstance = CoreDataStack()
    
    private override init() {}
    
    let charactersOperation: CharactersOperation = CharactersOperation()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "HeroModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("DumTekCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
        }
                
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func managedObjectContextObjectsDidSave(notification: Notification) {
        guard let contextSaved = notification.object as? NSManagedObjectContext else { return } 
        if  contextSaved != managedObjectContext && contextSaved.persistentStoreCoordinator == managedObjectContext.persistentStoreCoordinator {
            managedObjectContext.mergeChanges(fromContextDidSave: notification)
            print("save child")   
        }
    }
    
    func insertionContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator

        DispatchQueue.main.async {
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(self.managedObjectContextObjectsDidSave), name: NSNotification.Name.NSManagedObjectContextDidSave, object: context)            
        }
        
        return context
    }
    
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
}

extension NSManagedObjectContext {
    func saveChanges() {
        if hasChanges {
            do {
                try save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
