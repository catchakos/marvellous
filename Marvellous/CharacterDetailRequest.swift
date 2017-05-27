//
//  CharacterDetailRequest.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 27/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import Foundation
import Alamofire

class CharacterDetailRequest: MarvelApiRequest {
    
    var characterId: String
    var resourcePath: String {
        return  "v1/public/characters/character/" + characterId
    }
    var parameters: Parameters? {
        let privateData = createHashFromTimestampAndKeys()
        
        guard let hash = privateData["hash"], let ts = privateData["ts"], let apiKey = privateData["apikey"] else{
            return nil
        }
        
        let params: Parameters = [
            "limit": 20,
            "offset": 0,
            "hash": hash,
            "ts": ts,
            "apikey": apiKey
        ]
        return params
    }

    required init(identifier: String) {
        characterId = identifier
    }
}
