//
//  MarvelParser.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 26/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

protocol MarvelParseRequest {
    func inflateElementIfNeeded(_ json: JSON,_ intoContext: NSManagedObjectContext) -> Any?
}

class MarvelParser {
    var parseRequest: MarvelParseRequest
    
    required init(request: MarvelParseRequest) {
        parseRequest = request
    }
    
    func parse(json: JSON) -> [Any]? {
        let dataArray = json["data"]["results"] 
        var results = [Any]()
        for element in dataArray.array! {
            if let result = parseRequest.inflateElementIfNeeded(element, CoreDataStack.sharedInstance.managedObjectContext) {
                results.append(result)
            }
        }
        CoreDataStack.sharedInstance.saveContext()
        return results
    } 
}
