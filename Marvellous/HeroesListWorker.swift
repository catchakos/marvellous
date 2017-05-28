//
//  HeroesListWorker.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 28/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import UIKit
import CoreData

protocol HeroesListWorkerDelegate: class {
    func didFetchHeroes(_ heroes: [Hero]?, forRequest: MarvelApiRequest, ofType: HeroesListType)
}

class HeroesListWorker: NSObject, NSFetchedResultsControllerDelegate{
    
    var activeRequest: MarvelApiRequest?
    var requestType: HeroesListType?
    weak var delegate: HeroesListWorkerDelegate?
    
    override init() {
        super.init()
    }
    
    func fetch(request: MarvelApiRequest, type: HeroesListType) {
        activeRequest = request
        requestType = type
        
        switch type {
        case .AllHeroes:
            guard let req = request as? CharactersRequest else {
                return
            }
            fetchedResultsController.fetchRequest.fetchBatchSize = req.batchSize
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "identifier != 0")

        case .Search:
            guard let req = request as? CharactersSearchRequest else {
                return
            }
            fetchedResultsController.fetchRequest.fetchBatchSize = 0
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "identifier != 0 AND name BEGINSWITH %@", argumentArray: [req.searchText])
        }

        do {
            try fetchedResultsController.performFetch()
            print("FETCHED: \(String(describing: fetchedResultsController.fetchedObjects))")
        } catch {
            print("fetch failed")
        }

        remoteFetch()
    }
    
    func remoteFetch() {
        guard let request = activeRequest, let type = requestType else {
            return
        }
        switch type {
        case .AllHeroes:
            CoreDataStack.sharedInstance.charactersRepository.getCharacters(request as! CharactersRequest) { (newHeroes, error) in }            
        case .Search:
            CoreDataStack.sharedInstance.charactersRepository.getCharacters(request as! CharactersSearchRequest) { (newHeroes, error) in }
        }

    }
    
    // MARK: - Fetched results controller & Delegate
    var fetchedResultsController: NSFetchedResultsController<Hero> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest<Hero>()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entity(forEntityName: "Hero", in: CoreDataStack.sharedInstance.managedObjectContext)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<Hero>?
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let delegate = delegate,
           let request = activeRequest,
           let type = requestType {
            if let fetched = controller.fetchedObjects as? [Hero] {
                delegate.didFetchHeroes(fetched, forRequest: request, ofType: type)
            }
        }
    }
    
    
}
