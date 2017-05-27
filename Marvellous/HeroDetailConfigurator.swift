//
//  HeroDetailConfigurator.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 27/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import Foundation

extension HeroDetailViewController: HeroDetailViewPresenterOutput { }
extension HeroDetailInteractor: HeroDetailViewControllerOutput { }
extension HeroDetailViewPresenter: HeroDetailViewInteractorOutput { }

class HeroDetailConfigurator {
    
    func configure(_ vc: HeroDetailViewController) {
        let interactor = HeroDetailInteractor()
        vc.output = interactor
        
        let presenter = HeroDetailViewPresenter()
        presenter.output = vc
        interactor.output = presenter
    }
}
