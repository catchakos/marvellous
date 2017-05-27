//
//  CharactersParseRequest.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 27/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import Foundation
import SwiftyJSON

class CharactersParseRequest: MarvelParseRequest {
    
    func inflateElement(_ json: JSON) -> Any? {
        guard let name = json["name"].string, let desc = json["description"].string, let thumbPath = json["thumbnail"]["path"].string, let thumbExtension = json["thumbnail"]["extension"].string else {
            return nil
        } 
        
        let thumbUrl = thumbPath + "." + thumbExtension
        let hero = Hero(name, heroDescription: desc, heroThumbnailUrl: thumbUrl)
        return hero
    }
}
