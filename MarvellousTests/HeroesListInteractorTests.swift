//
//  HeroesListInteractorTests.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 28/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import XCTest
@testable import Marvellous

class HeroesListInteractorTests: XCTestCase {
    
    var outputSpy: HeroesListInteractorOutputSpy!
    var sut: HeroesListViewInteractor!
    var repoMock: RespositoryMock!
    var workerFake: HeroListWorkerFake!
    
    class HeroesListInteractorOutputSpy: HeroesListViewInteractorOutput {
        var presentCalled: Bool = false
        var emptyCalled: Bool = false
        var responseRecorded: HeroModels.List.Response!
        
        func presentCharacters(_ response: HeroModels.List.Response){
            presentCalled = true
            responseRecorded = response
        }
        
        func presentEmpty(_ type: HeroesListType, _ loading: Bool, _ message: String?) {
            emptyCalled = true
        }
    }
    
    class HeroListWorkerFake: HeroesListWorker {
        var repoMock: RespositoryMock!
        
        override func fetch(request: MarvelApiRequest, type: HeroesListType) {
            isFetching = true
            requestType = type
            let heroes = repoMock.givenThereAreHeroes()
            delegate?.didFetchHeroes(heroes, forRequest: request, ofType: type)
            isFetching = false
        }
    }
    
    override func setUp() {
        super.setUp()
        setupInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func setupInteractor() {
        repoMock = RespositoryMock()
        sut = HeroesListViewInteractor(repository: repoMock)
        sut.dataRepository = repoMock
        outputSpy = HeroesListInteractorOutputSpy()
        sut.output = outputSpy
        workerFake = HeroListWorkerFake()
        workerFake.repoMock = repoMock
        workerFake.delegate = sut
        sut.worker = workerFake
    }
    
    func testHeroesListInteractorCallsPresentWithDefaultCharacters() {        
        let request = HeroModels.List.DefaultRequest(page: 0)
        sut.fetchDefaultCharacters(request)
                
        XCTAssert(outputSpy.presentCalled)
    }
    
    func testHeroesListInteractorCallsPresentWithCharactersSearch() {        
        let request = HeroModels.List.SearchRequest(startsWith: "Hulk")
        sut.fetchCharactersStartingWith(request)

        XCTAssert(outputSpy.presentCalled)
    }
    
    func testHeroesListInteractorCallsPresentWithMeaningulResponseForCharactersSearch() {
        let request = HeroModels.List.SearchRequest(startsWith: "Fake")
        sut.fetchCharactersStartingWith(request)
        
        XCTAssertNotNil(self.outputSpy.responseRecorded)
        XCTAssertGreaterThan(self.outputSpy.responseRecorded.heroes.count, 0)
        XCTAssert((self.outputSpy.responseRecorded.heroes.first?.name?.contains("Fake"))!)
    }
    
    func testHeroesListInteractorReturnsCorrectCharacterIdentifier() {
        let request = HeroModels.List.DefaultRequest(page: 0)
        sut.fetchDefaultCharacters(request)

        XCTAssertEqual(sut.characterIdentifierAt(index: 0), 100)
    }
    
    func testHeroesListInteractorReturnsResultsWhenNextPageCalles() {
        repoMock.listState = (0, 200)
        
        let request = HeroModels.List.DefaultRequest(page: 0)
        sut.fetchDefaultCharacters(request)

        outputSpy.responseRecorded = nil
        sut.nextPage()
        
        XCTAssertGreaterThan(self.outputSpy.responseRecorded.heroes.count, 0)
    }
    
    func testHeroesListInteractorPresentsEmptyWhenSettingTypeToSearch() {
        sut.changeListType(typeIndex: 1)
        
        XCTAssert(outputSpy.emptyCalled)
    }
    
    func testHeroesListInteractorPresentsHeroesWhenSettingTypeToAllHeroes() {
        sut.changeListType(typeIndex: 0)
        
        XCTAssert(outputSpy.presentCalled)
    }
    
}
