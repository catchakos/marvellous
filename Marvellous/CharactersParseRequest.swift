//
//  CharactersParseRequest.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 27/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class CharactersParseRequest: MarvelParseRequest {
    
    func inflateElementIfNeeded(_ json: JSON,_ intoContext: NSManagedObjectContext) -> Any? {
        guard let name = json["name"].string,
              let desc = json["description"].string,
              let thumbPath = json["thumbnail"]["path"].string,
              let thumbExtension = json["thumbnail"]["extension"].string,
              let heroID = json["id"].int64
        else {
            return nil
        } 

        let thumbUrl = thumbPath + "." + thumbExtension
        
        
        let request = NSFetchRequest<Hero>(entityName: "Hero")
        let predicate = NSPredicate(format: "identifier == %@", argumentArray: [Int64(heroID)])
        request.predicate = predicate
        request.fetchLimit = 1
        
        do {
            let heroes = try intoContext.fetch(request) as [Hero]
            var hero = heroes.first
            if hero == nil {
                hero = NSEntityDescription.insertNewObject(forEntityName: "Hero", into: intoContext) as? Hero
            }
            hero?.name = name
            hero?.desc = desc
            hero?.thumbnailUrl = thumbUrl
            hero?.identifier = heroID
            return hero
        } catch let error as NSError {
            print(error.description)
            return nil
        }
    }
}
