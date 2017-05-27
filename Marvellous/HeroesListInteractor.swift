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
    
    func characterIdentifierAt(index: Int) -> Int64?
}

protocol HeroesListViewInteractorOutput {
    func presentCharacters(_ response: HeroModels.List.Response)
}

class HeroesListViewInteractor: HeroesListViewInteractorInput {
    
    var output: HeroesListViewInteractorOutput?
    private var heroes: [Hero]?
    
    func fetchDefaultCharacters(_ request: HeroModels.List.DefaultRequest) {
        let request = CharactersRequest()
        CoreDataStack.sharedInstance.modelInterface.getCharacters(request) { (newHeroes, error) in
            if let heroesFetched = newHeroes {
                self.heroes = heroesFetched
                let response = HeroModels.List.Response(heroes: heroesFetched)
                self.output?.presentCharacters(response)
            }
        }
    }
    
    func fetchCharactersStartingWith(_ request: HeroModels.List.SearchRequest) {
        let request = CharactersSearchRequest(text: request.startsWith)
        CoreDataStack.sharedInstance.modelInterface.getCharacters(request) { (newHeroes, error) in
            if let heroesFetched = newHeroes {
                self.heroes = heroesFetched
                let response = HeroModels.List.Response(heroes: heroesFetched)
                self.output?.presentCharacters(response)
            }
        }
    }
    
    func characterIdentifierAt(index: Int) -> Int64? {
        guard let heroes = heroes else { return nil }
        if heroes.count > index {
            return heroes[index].identifier
        }else{
            return nil
        }
    }
    
}
