//
//  HeroesListInteractorTests.swift
//  Marvellous
//
//  Created by Maria Pons Sanchez on 28/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import XCTest
@testable import Marvellous

class HeroesListInteractorTests: XCTestCase {
    
    var outputSpy: HeroesListInteractorOutputSpy!
    var sut: HeroesListViewInteractor!
    var repoMock: RespositoryMock!
    
    class HeroesListInteractorOutputSpy: HeroesListViewInteractorOutput {
        var presentCalled: Bool = false
        var responseRecorded: HeroModels.List.Response!
        
        func presentCharacters(_ response: HeroModels.List.Response){
            presentCalled = true
            responseRecorded = response
        }
    }
    
    override func setUp() {
        super.setUp()
        setupInteractor()
    }
    
    override func tearDown() {
        repoMock.clear()
        super.tearDown()
    }
    
    func setupInteractor() {
        repoMock = RespositoryMock()
        sut = HeroesListViewInteractor(repository: repoMock)
        sut.dataRepository = repoMock
        outputSpy = HeroesListInteractorOutputSpy()
        sut.output = outputSpy
    }
    
    func testHeroesListInteractorCallsPresentWithDefaultCharacters() {
        let request = HeroModels.List.DefaultRequest(page: 0)
        
        sut.fetchDefaultCharacters(request)
        
        XCTAssert(outputSpy.presentCalled)
    }
    
    func testHeroesListInteractorCallsPresentWithCharactersSearch() {
        let request = HeroModels.List.SearchRequest(startsWith: "Hul")
        
        sut.fetchCharactersStartingWith(request)
        
        XCTAssert(outputSpy.presentCalled)
    }
    
    func testHeroesListInteractorCallsPresentWithMeaningulResponseForCharactersSearch() {
        let request = HeroModels.List.SearchRequest(startsWith: "Hul")
        
        sut.fetchCharactersStartingWith(request)
        
        if let response = outputSpy.responseRecorded {
            XCTAssertGreaterThan(response.heroes.count, 0)
            if let hero = response.heroes.first?.name {
                XCTAssert(hero.contains("Fake"))
            }else{
                XCTFail()
            }
        }else{
            XCTFail()
        }
    }
    
}
