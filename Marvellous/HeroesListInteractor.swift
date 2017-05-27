//
//  HeroesListInteractor.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 27/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import Foundation

protocol HeroesListViewInteractorInput {
    func fetchDefaultCharacters(_ request: HeroModels.List.DefaultRequest)
    func fetchCharactersStartingWith(_ request: HeroModels.List.SearchRequest)    
}

protocol HeroesListViewInteractorOutput {
    func presentCharacters(_ response: HeroModels.List.Response)
}

class HeroesListViewInteractor: HeroesListViewInteractorInput {
    
    var output: HeroesListViewInteractorOutput?
    
    func fetchDefaultCharacters(_ request: HeroModels.List.DefaultRequest) {
        let request = CharactersRequest()
        let apiHandler = MarvelApiHandler()
        
        apiHandler.get(request) { (json, error) in
            if let jsonFetched = json {
                let charactersParseRequest = CharactersParseRequest()
                let parser = MarvelParser(request: charactersParseRequest)
                
                if let heroes : [Hero] = parser.parse(json: jsonFetched) as? [Hero] {
                    let response = HeroModels.List.Response(heroes: heroes)
                    self.output?.presentCharacters(response)
                }
            }else{
                // TODO: handle
            }
        }
    }
    
    func fetchCharactersStartingWith(_ request: HeroModels.List.SearchRequest) {
    
    }

}
