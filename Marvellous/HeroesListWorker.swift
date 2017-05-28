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
    func didNotFindSearchResults()
}

class HeroesListWorker: NSObject, NSFetchedResultsControllerDelegate{
    
    var activeRequest: MarvelApiRequest?
    var requestType: HeroesListType?
    weak var delegate: HeroesListWorkerDelegate?
    var isFetching: Bool = false
    
    var offset: Int = 0    

    override init() {
        super.init()
    }
    
    func fetch(request: MarvelApiRequest, type: HeroesListType) {
        activeRequest = request
        requestType = type
        
        switch type {
        case .AllHeroes:
            fetchedResultsController.fetchRequest.fetchBatchSize = heroesBatchSize
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "identifier != 0 && order > 0")

        case .Search:
            guard let req = request as? CharactersSearchRequest else {
                return
            }
            fetchedResultsController.fetchRequest.fetchBatchSize = 0
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "identifier != 0 AND name BEGINSWITH %@", argumentArray: [ req.searchText.capitalized ])
        }

        do {
            try fetchedResultsController.performFetch()
//            if let fetchedChunk = fetchedResultsController.fetchedObjects?.prefix(upTo: heroesBatchSize) {
//                informDelegate(withFetched: Array(fetchedChunk))
//            }
//            print("FETCHED: \(String(describing: fetchedResultsController.fetchedObjects))")
        } catch {
            print("fetch failed")
        }

        remoteFetch()
    }
    
    func remoteFetch() {
        guard let request = activeRequest, let type = requestType else {
            return
        }
        isFetching = true
        switch type {
        case .AllHeroes:
            if let allRequest = request as? CharactersRequest {
                offset = allRequest.offset
                print("getting characters with offset \(offset)")
                CoreDataStack.sharedInstance.charactersRepository.getCharacters(allRequest) { (success) in 
                    self.isFetching = false
                }
            }
        case .Search:
            if let searchRequest = request as? CharactersSearchRequest {
                CoreDataStack.sharedInstance.charactersRepository.getCharacters(searchRequest) { (success) in 
                    self.isFetching = false
                    if !success {
                        if let delegate = self.delegate {
                            delegate.didNotFindSearchResults()
                        }
                    }
                }
            }
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
        fetchRequest.fetchBatchSize = heroesBatchSize
        
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
        informDelegate(withFetched: fetchedResultsController.fetchedObjects)
    }
    
    func informDelegate(withFetched: [Hero]?) {
        if let delegate = delegate,
            let request = activeRequest,
            let type = requestType {
            if let fetched = withFetched as? [Hero] {
                delegate.didFetchHeroes(fetched, forRequest: request, ofType: type)
            }
        }
    }
    
}
