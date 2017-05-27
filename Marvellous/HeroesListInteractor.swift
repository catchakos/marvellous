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
    
    func characterIdentifierAt(index: Int) -> Int?
}

protocol HeroesListViewInteractorOutput {
    func presentCharacters(_ response: HeroModels.List.Response)
}

class HeroesListViewInteractor: HeroesListViewInteractorInput {
    
    var output: HeroesListViewInteractorOutput?
    private var heroes: [Hero]?
    
    func fetchDefaultCharacters(_ request: HeroModels.List.DefaultRequest) {
        let request = CharactersRequest()
        CoreDataStack.sharedInstance.modelInterface.getCharacters(request) { (heroes, error) in
            if let heroesFetched = heroes {
                let response = HeroModels.List.Response(heroes: heroesFetched)
                self.output?.presentCharacters(response)
            }
        }
    }
    
    func fetchCharactersStartingWith(_ request: HeroModels.List.SearchRequest) {
    
    }
    
    func characterIdentifierAt(index: Int) -> Int? {
        guard let heroes = heroes else { return nil }
        if heroes.count > index {
            return Int(heroes[index].identifier)
        }else{
            return nil
        }
    }
    
}
