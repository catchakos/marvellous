//
//  HeroesListViewPresenter.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 27/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import Foundation

protocol HeroesListViewPresenterInput {
    func presentCharacters(_ response: HeroModels.List.Response)
    func presentEmpty(_ type: HeroesListType, _ loading: Bool, _ message: String?)
}

protocol HeroesListViewPresenterOutput: class {
    func displayCharacters(_ viewModel: HeroModels.List.ViewModel)
    func displayEmpty(_ viewModel: HeroModels.List.EmptyListViewModel)
}

class HeroesListViewPresenter: HeroesListViewPresenterInput {
    
    weak var output: HeroesListViewPresenterOutput!
    
    func presentCharacters(_ response: HeroModels.List.Response) {
        print("present \(response.heroes.count) items")
        var heroesListModels: [HeroModels.List.ItemViewModel] = []
        for hero in response.heroes {
            guard let name = hero.name, 
                  let url = hero.thumbnailUrl
                else{
                    continue
            }
            let vm = HeroModels.List.ItemViewModel(name: name, thumbnailUrl: url)
            heroesListModels.append(vm)
        }
        let viewModel = HeroModels.List.ViewModel(items: heroesListModels, type: response.type, isLoading: response.isLoading)
        output.displayCharacters(viewModel)
    } 
    
    func presentEmpty(_ type: HeroesListType, _ loading: Bool, _ message: String?) {
        var msg = ""
        if let customMessage = message {
            msg = customMessage
        } else {
            switch type {
            case .AllHeroes:
                // TODO: should treat 1st load without connection case 
                msg = "Loading.."
            case .Search:
                if loading {
                    msg = "Loading.."
                } else {
                    msg = "No results"
                }
            }
        }
        let vm = HeroModels.List.EmptyListViewModel(message: msg, type: type, isLoading: loading)
        output.displayEmpty(vm)
    }
}
