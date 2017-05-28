//
//  HeroDetailInteractorTests.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 28/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import XCTest
@testable import Marvellous

class HeroDetailInteractorTests: XCTestCase {
    
    var sut : HeroDetailInteractor!
    var outputSpy: HeroDetailInteractorOutputSpy!
    var repoMock: RepositoryMock!
    
    class HeroDetailInteractorOutputSpy: HeroDetailViewInteractorOutput {
        var presentCalled : Bool = false
        var presentResponse : HeroModels.Detail.Response?
        
        func presentCharacterInfo(_ response: HeroModels.Detail.Response) {
            presentCalled = true
            presentResponse = response
        }
    }
    
    override func setUp() {
        super.setUp()
        setupInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
        repoMock.clear()
    }
    
    func setupInteractor() {
        repoMock = RepositoryMock()
        sut = HeroDetailInteractor(repository: repoMock)
        outputSpy = HeroDetailInteractorOutputSpy()
        sut.output = outputSpy
    }
    
    func testHeroDetailInteractorCallsPresent() {
        let request = HeroModels.Detail.Request(characterID: 100)
        
        sut.fetchCharacterInfo(request)
        
        XCTAssert(outputSpy.presentCalled)
    }
    
    func testHeroDetailInteractorCallsPresentWithMeaningfulInfo() {
        let request = HeroModels.Detail.Request(characterID: 100)
        
        sut.fetchCharacterInfo(request)
        
        XCTAssertEqual(outputSpy.presentResponse?.hero.name, "FakeHero")
        XCTAssertEqual(outputSpy.presentResponse?.hero.identifier, 100)
    }
}
