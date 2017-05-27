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
        struct Request {
            
        }
        struct SearchRequest {
            let startsWith: String
        }
        struct Response {
            
        }
        struct ViewModel {
            let name: String
            let thumbnailUrl: String
        }
    }
    
    struct Detail {
        struct Request {
            
        }
        struct Response {
            
        }
        struct ViewModel {
            let name: String
            let thumbnailUrl: String
            let description: String
        }
    }
}
