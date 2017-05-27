//
//  MarvelParser.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 26/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol MarvelParseRequest {
    func inflateElement(_ json: JSON) -> Any?
}

class MarvelParser {
    var parseRequest: MarvelParseRequest
    
    required init(request: MarvelParseRequest) {
        parseRequest = request
    }
    
    func parse(json: JSON) {
        let dataArray = json["data"]["results"] 
        var results = [Any]()
        for element in dataArray.array! {
            if let result = parseRequest.inflateElement(element) {
                results.append(result)
            }
        }
        print("\(results)")
    } 
    
}
