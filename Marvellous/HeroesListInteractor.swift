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
    
    func changeListType(typeIndex: Int)
    func characterIdentifierAt(index: Int) -> Int64?
    func nextPage()
}

protocol HeroesListViewInteractorOutput {
    func presentCharacters(_ response: HeroModels.List.Response)
    func presentEmpty(_ type: HeroesListType)
}

enum HeroesListType {
    case AllHeroes
    case Search
}

class HeroesListViewInteractor: HeroesListViewInteractorInput, HeroesListWorkerDelegate {
    
    var output: HeroesListViewInteractorOutput?

    private var heroes = [Hero]()
    private var worker: HeroesListWorker =  HeroesListWorker()
    var dataRepository: CharactersRepository
    
    required init(repository: CharactersRepository) {
        dataRepository = repository
        worker.delegate = self
    }
    
    func fetchDefaultCharacters(_ request: HeroModels.List.DefaultRequest) {
        fetchAllCharactersFromOffset(offset: 0)
    }
    
    func fetchCharactersStartingWith(_ request: HeroModels.List.SearchRequest) {
        let request = CharactersSearchRequest(text: request.startsWith)
        worker.fetch(request: request, type: .Search)
    }
    
    func fetchAllCharactersFromOffset(offset: Int) {
        let request = CharactersRequest()
        request.offset = offset
        worker.fetch(request: request, type: .AllHeroes)
    }
    
    func nextPage() {
        if worker.requestType == .AllHeroes && !worker.isFetching {
            fetchAllCharactersFromOffset(offset: worker.offset + worker.batchSize)
        }
    }
    
    func changeListType(typeIndex: Int) {
        switch typeIndex {
        case 0:
            worker.requestType = .AllHeroes
            heroes.removeAll()    
            output?.presentEmpty(.AllHeroes)
            fetchAllCharactersFromOffset(offset: 0)
        case 1:
            worker.requestType = .Search
            output?.presentEmpty(.Search)
        default:
            break
        }
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
            let response = HeroModels.List.Response(heroes: self.heroes, type: ofType)
            self.output?.presentCharacters(response)
        }
    }

}
