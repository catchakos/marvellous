//
//  HeroDetailViewPresenter.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 27/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import Foundation

protocol HeroDetailViewPresenterInput {
    func presentCharacterInfo(_ response: HeroModels.Detail.Response)
}

protocol HeroDetailViewPresenterOutput: class {
    func displayCharacterInfo(_ viewModel: HeroModels.Detail.ViewModel)
}

class HeroDetailViewPresenter: HeroDetailViewPresenterInput {
    
    weak var output: HeroDetailViewPresenterOutput!
    
    func presentCharacterInfo(_ response: HeroModels.Detail.Response) {
        
    } 
}
