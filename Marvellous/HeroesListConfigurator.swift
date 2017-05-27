//
//  HeroListConfigurator.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 27/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import Foundation

extension HeroesListViewController: HeroesListViewPresenterOutput { }
extension HeroesListViewInteractor: HeroesListViewControllerOutput { }
extension HeroesListViewPresenter: HeroesListViewInteractorOutput { }

class HeroesListConfigurator {
    
    func configure(_ vc: HeroesListViewController) {
        let interactor = HeroesListViewInteractor(repository: CoreDataStack.sharedInstance.modelInterface)
        vc.output = interactor
        
        let presenter = HeroesListViewPresenter()
        presenter.output = vc
        interactor.output = presenter
    }
}
