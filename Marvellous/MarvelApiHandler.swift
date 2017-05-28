//
//  MarvelApiHandler.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 26/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import Foundation
import Alamofire
import CryptoSwift
import SwiftyJSON

protocol MarvelApiRequest {
    var resourcePath: String {get}
    var parameters: Parameters? {get}
    var parseRequest: MarvelParseRequest? {get}
}

class MarvelApiHandler {

    let baseMarvelURL = "https://gateway.marvel.com/"

    func get(_ request: MarvelApiRequest, completion: @escaping(_ responseData: JSON?, _ error: Error?) -> Void) {
        let resourceCompleteURL = baseMarvelURL + request.resourcePath
        guard let params = request.parameters else {
            // TODO: return error
            completion(nil, nil)
            return
        }
        Alamofire.request(resourceCompleteURL, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("\(json)")
                completion(json, nil)
            case .failure(let error):
                print(error)
                completion(nil, error)
            }
        }
    }
}
