//
//  HeroDetailPresenterTests.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 28/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import XCTest
@testable import Marvellous 

class HeroDetailPresenterTests: XCTestCase {
    var sut: HeroDetailViewPresenter! 
    var outputSpy: HeroDetailViewPresenterOutputSpy!
    var repoMock: RepositoryMock!

    class HeroDetailViewPresenterOutputSpy: HeroDetailViewPresenterOutput {
        var displayCalled: Bool = false
        var viewModelPassed: HeroModels.Detail.ViewModel?
        
        func displayCharacterInfo(_ viewModel: HeroModels.Detail.ViewModel) {
            displayCalled = true
            viewModelPassed = viewModel
        }
    }
    
    override func setUp() {
        super.setUp()
        setupPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
        repoMock.clear()
    }
    
    func setupPresenter() {
        repoMock = RepositoryMock()
        sut = HeroDetailViewPresenter()
        outputSpy = HeroDetailViewPresenterOutputSpy()
        sut.output = outputSpy
    }
    
    func testHeroDetailViewPresenterCallsDisplay() {
        let hero = repoMock.givenThereAreHeroes().first as! Hero
        let response = HeroModels.Detail.Response(hero: hero)
                
        sut.presentCharacterInfo(response)
        
        XCTAssert(outputSpy.displayCalled)
    }
    
    func testHeroDetailViewPresenterCallsDisplayWithMeaningfulInfo() {
        let hero = repoMock.givenThereAreHeroes().first as! Hero
        let response = HeroModels.Detail.Response(hero: hero)
        
        sut.presentCharacterInfo(response)
        
        XCTAssertEqual(outputSpy.viewModelPassed?.name, "FakeHero")
        XCTAssertEqual(outputSpy.viewModelPassed?.description, "FakeDescription")
        XCTAssertEqual(outputSpy.viewModelPassed?.thumbnailUrl, "http://url")
    }
}
