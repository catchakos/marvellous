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
        _ = repoMock.givenThereAreHeroes()
        
        let request = HeroModels.List.DefaultRequest(page: 0)
        sut.fetchDefaultCharacters(request)
        
        let expect = expectation(description: "presentCalled")
        //TODO: this is not the way..
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            XCTAssert(self.outputSpy.presentCalled)
            expect.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testHeroesListInteractorCallsPresentWithCharactersSearch() {
        _ = repoMock.givenThereAreHeroes()
        
        let request = HeroModels.List.SearchRequest(startsWith: "Hulk")
        sut.fetchCharactersStartingWith(request)
        
        let expect = expectation(description: "presentCalled")
        //TODO: this is not the way..
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            XCTAssert(self.outputSpy.presentCalled)
            expect.fulfill()
        })
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testHeroesListInteractorCallsPresentWithMeaningulResponseForCharactersSearch() {
        _ = repoMock.givenThereAreHeroes()
        
        let request = HeroModels.List.SearchRequest(startsWith: "Hulk")
        sut.fetchCharactersStartingWith(request)
        
        let expect = expectation(description: "presentCalled")
        //TODO: this is not the way..
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            XCTAssertNotNil(self.outputSpy.responseRecorded)
            XCTAssertGreaterThan(self.outputSpy.responseRecorded.heroes.count, 0)
            XCTAssert((self.outputSpy.responseRecorded.heroes.first?.name?.contains("Hulk"))!)
            expect.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
}
