//
//  Hero.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 27/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import Foundation

class Hero {
    var name: String
    var identifier: Int
    var description: String
    var thumbnailUrl: String
    
    var modified: Date?
    var seriesTitles: [String]?
    
    required init(_ heroName: String, heroId: Int, heroDescription: String, heroThumbnailUrl: String) {
        name = heroName
        description = heroDescription
        thumbnailUrl = heroThumbnailUrl
        identifier = heroId
    }
}
