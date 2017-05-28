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
    
    func parse(json: JSON) -> (offsetReached: Int, total: Int) {
        let dataArray = json["data"]["results"] 
        
        var offsetReached = 0
        var totalCount = 0
        if let offset = json["data"]["offset"].int,
            let count = json["data"]["count"].int,
            let total = json["data"]["total"].int {
            offsetReached = offset + count
            totalCount = total
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let context = CoreDataStack.sharedInstance.insertionContext()
            for element in dataArray.array! {
                _ = self.parseRequest.inflateElementIfNeeded(element, context)
            }
            context.saveChanges()
        } 
        return (offsetReached, totalCount)
    }
}
