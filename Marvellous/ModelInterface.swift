//
//  ModelInterface.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 27/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class ModelInterface {
    
    private var completionHandler: (([Hero]?,Error?) -> Void)?
    
    func getCharacters(_ request: CharactersRequest, completion: @escaping(_ responseHeroes: [Hero]?, _ error: Error?) -> Void) {
        completionHandler = completion
        
        fetchLocalCharacters()
        fetchCharactersRemotely(request)
    }

    func informHeroes(_ heroes: [Hero]?) {
        if let closure = completionHandler {
            closure(heroes, nil)            
        }
    }

    func informError(_ error: Error?) {
        if let closure = completionHandler {
            closure(nil, error)            
        }
    }
    
    func fetchLocalCharacters() {
        let request = NSFetchRequest<Hero>(entityName: "Hero")
        let predicate = NSPredicate(format: "identifier != 0")
        request.predicate = predicate
        
        do {
            let heroes = try CoreDataStack.sharedInstance.managedObjectContext.fetch(request) as [Hero]
            informHeroes(heroes)
        } catch let error as NSError {
            print(error.description)
            informHeroes(nil)
        }
    }
    
    func fetchCharactersRemotely(_ request: CharactersRequest) {
        let apiHandler = MarvelApiHandler()
        apiHandler.get(request) { (json, error) in
            if let jsonFetched = json {
                if let charactersParseRequest = request.parseRequest {
                    let parser = MarvelParser(request: charactersParseRequest)
                    if let heroesFetched : [Hero] = parser.parse(json: jsonFetched) as? [Hero] {
                        if let closure = self.completionHandler {
                            closure(heroesFetched, nil)
                        }
                    }else{
                        self.informError(nil)
                    }
                }else{
                    self.informError(error)
                }
            }else{
                self.informError(error)
            }
        }
    }
}
