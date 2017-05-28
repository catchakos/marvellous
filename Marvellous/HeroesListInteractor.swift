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
    func presentEmpty(_ type: HeroesListType, _ loading: Bool, _ message: String?)
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
        if request.startsWith.characters.count > 2 {
            let request = CharactersSearchRequest(text: request.startsWith)
            worker.fetch(request: request, type: .Search)
        }else{
            output?.presentEmpty(.Search, false, "Should type more than 2 characters to search..")
        }
    }
    
    func fetchAllCharactersFromOffset(offset: Int) {
        let request = CharactersRequest()
        request.offset = offset
        worker.fetch(request: request, type: .AllHeroes)
    }
    
    func nextPage() {
        if worker.requestType == .AllHeroes && !worker.isFetching && self.heroes.count < dataRepository.listState.total {
            let offset = max(worker.offset + heroesBatchSize, self.heroes.count)
            fetchAllCharactersFromOffset(offset: offset)
            
            let response = HeroModels.List.Response(heroes: self.heroes, type: .AllHeroes, isLoading: worker.isFetching)
            output?.presentCharacters(response)
        }
    }
    
    func changeListType(typeIndex: Int) {
        switch typeIndex {
        case 0:
            worker.requestType = .AllHeroes
            heroes.removeAll()    
            output?.presentEmpty(.AllHeroes, true, nil)
            fetchAllCharactersFromOffset(offset: 0)
        case 1:
            worker.requestType = .Search
            output?.presentEmpty(.Search, false, nil)
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
        print("worker did fetch \(heroesFetched!.count)")
        if let fetchedHeroes = heroesFetched {
            self.heroes = fetchedHeroes 
            print("interactor has \(self.heroes.count) heroes")
            let response = HeroModels.List.Response(heroes: self.heroes, type: ofType, isLoading: worker.isFetching)
            self.output?.presentCharacters(response)
        }
    }
    
    func didNotFindSearchResults() {
        output?.presentEmpty(.Search, false, nil)
    }

}
