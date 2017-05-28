//
//  CharactersRepository.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 27/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class CharactersRepository {
    
    private var completionHandler: ((Bool) -> Void)?
    var listState : (offsetReached: Int, total: Int) = (0, Int.max)
    
    func getCharacters(_ request: CharactersRequest, completion: @escaping(_ success: Bool) -> Void) {
        completionHandler = completion
        fetchCharactersRemotely(request)
    }
    
    func getCharacters(_ request: CharactersSearchRequest, completion: @escaping(_ success: Bool) -> Void) {
        completionHandler = completion
        fetchCharactersRemotely(request)
    }
    
    func getCharacter(_ identifier: Int64) -> Hero? {
        let request = NSFetchRequest<Hero>(entityName: "Hero")
        let predicate = NSPredicate(format: "identifier = %@", argumentArray: [identifier])
        request.predicate = predicate
        request.fetchLimit = 1
        
        do {
            let heroes = try CoreDataStack.sharedInstance.managedObjectContext.fetch(request) as [Hero]
            return heroes.first    
        } catch let error as NSError {
            print(error.description)
            return nil
        }
    }

    private func informSuccess(_ success: Bool) {
        if let closure = completionHandler {
            closure(success)            
        }
    }
    
    private func fetchCharactersRemotely(_ request: MarvelApiRequest) {
        let apiHandler = MarvelApiHandler()
        apiHandler.get(request) { (json, error) in
            if let jsonFetched = json {
                if let charactersParseRequest = request.parseRequest {
                    let ordered = request is CharactersRequest
                    let parser = MarvelParser(request: charactersParseRequest, ordered:ordered) 
                    self.listState = parser.parse(json: jsonFetched)
                    self.informSuccess(self.listState.total > 0)
                }else{
                    self.informSuccess(false)
                }
            }else{
                self.informSuccess(false)
            }
        }
    }
    
}
