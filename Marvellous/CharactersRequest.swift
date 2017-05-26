//
//  CharactersRequest.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 26/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import Foundation
import Alamofire

class CharactersRequest: MarvelApiRequest {
    
    let resourcePath = "v1/public/characters"
    
    var parameters: Parameters {
        let searchText = "Hulk"
        
        let privateData = createHashFromTimestampAndKeys()
        
        let hash = privateData["hash"]
        let ts = privateData["ts"]
        let apiKey = privateData["apiKey"]
        
        let params: Parameters = [
            "nameStartsWith": searchText,
            "limit": 20,
            "offset": 0,
            "hash": hash as Any,
            "ts": ts as Any,
            "apikey": apiKey as Any
        ]
        return params
    }
}
