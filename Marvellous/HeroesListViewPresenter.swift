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
}

protocol HeroesListViewPresenterOutput: class {
    func displayCharacters(_ viewModel: HeroModels.List.ViewModel)
}

class HeroesListViewPresenter: HeroesListViewPresenterInput {
    
    weak var output: HeroesListViewPresenterOutput!
    
    func presentCharacters(_ response: HeroModels.List.Response) {
        
    } 
}
