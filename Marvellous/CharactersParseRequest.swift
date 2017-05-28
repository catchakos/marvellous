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
    
    func inflateElementIfNeeded(_ json: JSON,_ intoContext: NSManagedObjectContext, _ order : Int?) -> Any? {
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
        //TODO: check modified date as well
        let predicate = NSPredicate(format: "identifier == %@ AND order > 0", argumentArray: [Int64(heroID)])
        request.predicate = predicate
        request.fetchLimit = 1
        
        do {
            let heroes = try intoContext.fetch(request) as [Hero]
            var hero = heroes.first
            if hero == nil {
                hero = NSEntityDescription.insertNewObject(forEntityName: "Hero", into: intoContext) as? Hero
            }
            hero?.name = name
            if desc == "" {
                hero?.desc = "No Description.."
            }else{
                hero?.desc = desc
            }
            hero?.thumbnailUrl = thumbUrl
            hero?.identifier = heroID
            if let heroOrder = order {
                hero?.order = Int64(heroOrder)
            }
            
            if let jsonSeries = json["series"]["items"].array {
                for oneJsonSeries in jsonSeries {
                    if let series = NSEntityDescription.insertNewObject(forEntityName: "Series", into: intoContext) as? Series {
                        series.name = oneJsonSeries["name"].string
                        series.resourceURI = oneJsonSeries["resourceURI"].string
                        hero?.addToAppearsInSeries(series)
                    }
                }
            }
            
            if let jsonComics = json["comics"]["items"].array {
                for jsonComic in jsonComics {
                    if let comic = NSEntityDescription.insertNewObject(forEntityName: "Comic", into: intoContext) as? Comic {
                        comic.name = jsonComic["name"].string
                        comic.resourceURI = jsonComic["resourceURI"].string
                        hero?.addToAppearsInComics(comic)
                    }
                }
            }
            
            return hero
        } catch let error as NSError {
            print(error.description)
            return nil
        }
    }
    
    
}
