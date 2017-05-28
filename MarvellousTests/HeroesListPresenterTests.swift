//
//  HeroesListPresenterTests.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 28/05/2017.
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
        var displayEmptyCalled: Bool = false
        var viewModelRecorded: HeroModels.List.ViewModel!
        var emptyViewModelRecorded: HeroModels.List.EmptyListViewModel!

        func displayCharacters(_ viewModel: HeroModels.List.ViewModel) {
            viewModelRecorded = viewModel
            displayCalled = true
        }
        
        func displayEmpty(_ viewModel: HeroModels.List.EmptyListViewModel) {
            emptyViewModelRecorded = viewModel
            displayEmptyCalled = true
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
    
    func testHeroesListPresenterCallsDisplayCharacters() {
        let heroes = repoMock.givenThereAreHeroes()
        
        let response = HeroModels.List.Response(heroes: heroes, type: .AllHeroes, isLoading: false)
        sut.presentCharacters(response)
        
        XCTAssert(outputSpy.displayCalled)
    }
    
    func testHeroesListPresenterCallsDisplayEmpty() {
        sut.presentEmpty(.Search, true, nil)
        
        XCTAssert(outputSpy.displayEmptyCalled)
    }
    
    func testHeroesListPresenterCallsDisplayCharactersWithMeaningfulViewModel() {
        let heroes = repoMock.givenThereAreHeroes()
        
        let response = HeroModels.List.Response(heroes:heroes, type: .AllHeroes, isLoading: false)
        sut.presentCharacters(response)
        
        XCTAssertEqual(outputSpy.viewModelRecorded.items.count, heroes.count)
        if let hero = outputSpy.viewModelRecorded.items.first {
            XCTAssertEqual(hero.name, "FakeHero")
            XCTAssertEqual(hero.thumbnailUrl, "http://url")
        }else{
            XCTFail()
        }
    }
    
    func testHeroesListPresenterPreservesLoadingState() {
        sut.presentEmpty(.AllHeroes, true, nil)
        
        XCTAssert(outputSpy.emptyViewModelRecorded.isLoading)
    }
    
    func testHeroesListPresenterPreservesNotLoadingState() {
        sut.presentEmpty(.AllHeroes, false, nil)
        
        XCTAssertFalse(outputSpy.emptyViewModelRecorded.isLoading)
    }
    
    func testHeroesListPresenterDislaysNoResultsCorrectly() {
        sut.presentEmpty(.Search, false, nil)
        
        XCTAssertEqual(outputSpy.emptyViewModelRecorded.message, "No results")
    }
    
    func testHeroesListPresenterDislaysLoadingCorrectly() {
        sut.presentEmpty(.AllHeroes, false, nil)
        
        XCTAssertEqual(outputSpy.emptyViewModelRecorded.message, "Loading..")
    }

    func testHeroesListPresenterCustomMessageCorrectly() {
        sut.presentEmpty(.Search, false, "custom")
        
        XCTAssertEqual(outputSpy.emptyViewModelRecorded.message, "custom")
    }

}

