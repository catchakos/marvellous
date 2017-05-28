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

enum HeroesListType {
    case AllHeroes
    case Search
}

class HeroesListViewInteractor: HeroesListViewInteractorInput, HeroesListWorkerDelegate {
    
    var output: HeroesListViewInteractorOutput?
    private var heroes = [Hero]()
    private var worker: HeroesListWorker =  HeroesListWorker()
    
    init() {
        worker.delegate = self
    }
    
    
    func fetchDefaultCharacters(_ request: HeroModels.List.DefaultRequest) {
        let request = CharactersRequest()
        worker.fetch(request: request, type: .AllHeroes)
    }
    
    func fetchCharactersStartingWith(_ request: HeroModels.List.SearchRequest) {
        let request = CharactersSearchRequest(text: request.startsWith)
        worker.fetch(request: request, type: .Search)
    }
    
    func characterIdentifierAt(index: Int) -> Int64? {
        if heroes.count > index {
            return heroes[index].identifier
        }else{
            return nil
        }
    }
    
    
    // MARK - HeroesList Worker Delegate
    func didFetchHeroes(_ heroesFetched: [Hero]?, forRequest: MarvelApiRequest, ofType: HeroesListType) {
        switch ofType {
        case .AllHeroes:
            break
        case .Search:
            heroes.removeAll()    
        }
        
        if let fetchedHeroes = heroesFetched {
            self.heroes.append(contentsOf:fetchedHeroes)  
            let response = HeroModels.List.Response(heroes: self.heroes)
            self.output?.presentCharacters(response)
        }
    }

}
