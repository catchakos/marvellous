//
//  HeroDetailInteractor.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 27/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import Foundation

protocol HeroDetailViewInteractorInput {
    func fetchCharacterInfo(_ request: HeroModels.Detail.Request)
}

protocol HeroDetailViewInteractorOutput {
    func presentCharacterInfo(_ response: HeroModels.Detail.Response)
}

class HeroDetailInteractor: HeroDetailViewInteractorInput {
    
    var output: HeroDetailViewInteractorOutput?
    var dataRepository: CharactersRepository

    required init(repository: CharactersRepository) {
        dataRepository = repository
    }
    
    func fetchCharacterInfo(_ request: HeroModels.Detail.Request) {
        if let hero = dataRepository.getCharacter(request.characterID) {           
            let response = HeroModels.Detail.Response(hero: hero)
            output?.presentCharacterInfo(response)
        }
    }
    
}
