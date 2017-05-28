//
//  HeroModels.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 27/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import Foundation

struct HeroModels {
    struct List {
        struct DefaultRequest {
            let page: Int
        }
        struct SearchRequest {
            let startsWith: String
        }
        struct Response {
            let heroes: [Hero]
        }
        struct ViewModel {
            let items: [ItemViewModel]
        }
        struct ItemViewModel {
            let name: String
            let thumbnailUrl: String
        }
    }
    
    struct Detail {
        struct Request {
            let characterID: Int64
        }
        struct Response {
            let hero: Hero
        }
        struct ViewModel {
            let name: String
            let thumbnailUrl: String
            let description: String
            let seriesNames: [String]
            let comicsNames: [String]
        }
    }
}
