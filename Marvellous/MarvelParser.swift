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
    
    func parse(json: JSON) {
        let dataArray = json["data"]["results"] 
        
        DispatchQueue.global(qos: .userInitiated).async {
            for element in dataArray.array! {
                let context = CoreDataStack.sharedInstance.insertionContext()
                _ = self.parseRequest.inflateElementIfNeeded(element, context)
            }
        } 
    }
}
