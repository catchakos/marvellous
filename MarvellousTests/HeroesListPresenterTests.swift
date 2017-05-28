//
//  HeroesListPresenterTests.swift
//  Marvellous
//
//  Created by Maria Pons Sanchez on 28/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import XCTest
@testable import Marvellous

class HeroesListPresenterTests: XCTestCase {
    var outputSpy: HeroesListViewPresenterOutputSpy!
    var sut: HeroesListViewPresenter!
    var repoMock: RespositoryMock!
    
    class HeroesListViewPresenterOutputSpy: HeroesListViewPresenterOutput {
        var displayCalled: Bool = false
        var viewModelRecorded: HeroModels.List.ViewModel!
        
        func displayCharacters(_ viewModel: HeroModels.List.ViewModel) {
            viewModelRecorded = viewModel
            displayCalled = true
        }
    }

    override func setUp() {
        super.setUp()
        setupPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func setupPresenter() {
        repoMock = RespositoryMock()
        sut = HeroesListViewPresenter()
        outputSpy = HeroesListViewPresenterOutputSpy()
        sut.output = outputSpy
    }
    
    func testDisplayCharactersIsCalled() {
        let heroes = repoMock.givenThereAreHeroes()
        
        let response = HeroModels.List.Response(heroes:heroes)
        sut.presentCharacters(response)
        
        XCTAssert(outputSpy.displayCalled)
    }
    
    func testDisplayCharactersIsCalledWithMeaningfulViewModel() {
        let heroes = repoMock.givenThereAreHeroes()
        
        let response = HeroModels.List.Response(heroes:heroes)
        sut.presentCharacters(response)
        
        XCTAssertEqual(outputSpy.viewModelRecorded.items.count, heroes.count)
        if let hero = outputSpy.viewModelRecorded.items.first {
            XCTAssertEqual(hero.name, "FakeHero")
        }else{
            XCTFail()
        }
    }
    
}

