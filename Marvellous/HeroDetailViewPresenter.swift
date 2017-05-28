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
        let hero = response.hero
        guard let name = hero.name, 
              let url = hero.thumbnailUrl,
              let desc = hero.desc,
              let comics = hero.appearsInComics,
              let series = hero.appearsInSeries
        else {
            return
        }

        var seriesNames = [String]() 
        var comicsNames = [String]()
        if let comicsArray = Array(comics) as? [Comic] {
            comicsNames = comicsArray.map { $0.name! }
        }
        if let seriesArray = Array(series) as? [Series] {
            seriesNames = seriesArray.map { $0.name! }
        }
        
        let model = HeroModels.Detail.ViewModel(name: name, thumbnailUrl: url, description: desc, seriesNames: seriesNames, comicsNames: comicsNames)
        output.displayCharacterInfo(model)
    } 
}
