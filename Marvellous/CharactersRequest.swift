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
    var parseRequest: MarvelParseRequest? {
        return CharactersParseRequest()
    }
    let batchSize = 50
    var offset = 0
    
    var parameters: Parameters? {
        let privateData = createHashFromTimestampAndKeys()
        
        guard let hash = privateData["hash"], let ts = privateData["ts"], let apiKey = privateData["apikey"] else{
            return nil
        }
        
        let params: Parameters = [
            "limit": batchSize,
            "offset": offset,
            "hash": hash,
            "ts": ts,
            "apikey": apiKey
        ]
        return params
    }
}
