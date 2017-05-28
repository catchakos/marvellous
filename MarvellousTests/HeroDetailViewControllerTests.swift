//
//  HeroDetailViewControllerTests.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 28/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import XCTest
@testable import Marvellous 

class HeroDetailViewControllerTests: XCTestCase {
    
    var sut: HeroDetailViewController!
    var outputSpy: HeroDetailViewControllerOutputSpy!
    
    class HeroDetailViewControllerOutputSpy: HeroDetailViewControllerOutput {
        var fetchCalled: Bool = false
        var fetchRequested: HeroModels.Detail.Request!
        
        func fetchCharacterInfo(_ request: HeroModels.Detail.Request){
            fetchCalled = true
            fetchRequested = request
        }
    }
    
    
    override func setUp() {
        super.setUp()
        setupViewController()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func setupViewController() {
        outputSpy = HeroDetailViewControllerOutputSpy()
        let story = UIStoryboard(name: "Main", bundle: Bundle.main)
        sut = story.instantiateViewController(withIdentifier: "HeroDetailViewController") as! HeroDetailViewController
        sut.output = outputSpy
    }
    
    func testHeroDetailViewControllerCallsFetchCharacter() {
        sut.heroID = 100
        
        XCTAssert(outputSpy.fetchCalled)
    }
    
    func testHeroDetailViewControllerCallsFetchCharacterWithMeaningfulRequest() {
        sut.heroID = 100

        XCTAssertEqual(outputSpy.fetchRequested.characterID, 100)
    }
    
    func testHeroDetailViewControllerFillsDescription() {
        sut.loadView()
        
        let vm = createFakeViewModel()
        sut.displayCharacterInfo(vm)
        
        XCTAssertEqual(sut.detailDescription.text, "desc")
    }

//    func testHeroDetailViewControllerFillsImage() {
//        let vm = createFakeViewModel()
//        sut.displayCharacterInfo(vm)
//        
//        XCTAssert(sut.detailImageView.image)
//    }
    
    func testHeroDetailViewControllerStartsSpinner() {
        sut.loadView()
        
        XCTAssert(sut.spinner.isAnimating)
    }
    
    func testHeroDetailViewControllerStopsSpinner() {
        sut.loadView()
        
        let vm = createFakeViewModel()
        sut.displayCharacterInfo(vm)
        
        XCTAssertFalse(sut.spinner.isAnimating)        
    }
    
    func createFakeViewModel() -> HeroModels.Detail.ViewModel {
        let vm = HeroModels.Detail.ViewModel(name: "name", thumbnailUrl: "url", description: "desc", seriesNames: ["s1","s2"], comicsNames: ["c1"])
        return vm
    }
}
