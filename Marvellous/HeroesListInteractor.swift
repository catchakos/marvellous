//
//  HeroesListInteractor.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 27/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import Foundation

protocol HeroesListViewInteractorInput {
    func fetchDefaultCharacters(_ request: HeroModels.List.Request)
    func fetchCharactersStartingWith(_ request: HeroModels.List.SearchRequest)    
}

protocol HeroesListViewInteractorOutput {
    func presentCharacters(_ response: HeroModels.List.Response)
}

class HeroesListViewInteractor: HeroesListViewInteractorInput {
    
    var output: HeroesListViewInteractorOutput?
    
    func fetchDefaultCharacters(_ request: HeroModels.List.Request) {
        
    }
    
    func fetchCharactersStartingWith(_ request: HeroModels.List.SearchRequest) {
    
    }

}
