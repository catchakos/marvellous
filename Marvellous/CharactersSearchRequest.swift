//
//  CharactersSearchRequest.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 27/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import Foundation
import Alamofire

class CharactersSearchRequest: MarvelApiRequest {
    let resourcePath = "v1/public/characters"
    var parseRequest: MarvelParseRequest? {
        return CharactersParseRequest()
    }
    var searchText: String
    
    required init(text: String) {
        searchText = text
    }
    
    var parameters: Parameters? {
        let privateData = createHashFromTimestampAndKeys()
        
        guard let hash = privateData["hash"], let ts = privateData["ts"], let apiKey = privateData["apikey"] else{
            return nil
        }
        
        let params: Parameters = [
            "nameStartsWith": searchText,
            "offset": 0,
            "hash": hash,
            "ts": ts,
            "apikey": apiKey
        ]
        return params
    }
}
