//
//  HeroesListViewControllerTests.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 28/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import XCTest
@testable import Marvellous

class HeroesListViewControllerTests: XCTestCase {
    
    var sut: HeroesListViewController!    
    var outputSpy: HeroesListViewControllerOutputSpy!
    
    class HeroesListViewControllerOutputSpy: HeroesListViewControllerOutput {
        var fetchDefaultCalled : Bool = false
        var fetchDefaultRequest : HeroModels.List.DefaultRequest? 
        var fetchSearchCalled: Bool = false
        var fetchSearchReqeust: HeroModels.List.SearchRequest?
        var nextPageCalled : Bool = false
        var changeListCalled : Bool = false
        var characterIDCalled : Bool = false
        
        func fetchDefaultCharacters(_ request: HeroModels.List.DefaultRequest){
            fetchDefaultCalled = true
            fetchDefaultRequest = request
        }
        func fetchCharactersStartingWith(_ request: HeroModels.List.SearchRequest){
            fetchSearchCalled = true
            fetchSearchReqeust = request
        }
        func characterIdentifierAt(index: Int) -> Int64?{
            characterIDCalled = true
            return 100
        }
        func changeListType(typeIndex: Int){
            changeListCalled = true
        }
        func nextPage(){
            nextPageCalled = true
        }
    }
    
    class HeroesListCollectionFake: NSObject, UICollectionViewDataSource {
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 5
        }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            return UICollectionViewCell()
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
        outputSpy = HeroesListViewControllerOutputSpy()
        let story = UIStoryboard(name: "Main", bundle: Bundle.main)
        sut = story.instantiateViewController(withIdentifier: "HeroesListViewController") as! HeroesListViewController
        sut.output = outputSpy
    }
    
    func testHeroesListViewControllerCollectionViewHasFrame() {
        sut.loadView()
        
        XCTAssertNotEqual(sut.collectionView.frame, CGRect.zero)
    }

    func testHeroesListViewControllerSwitcherHasFrame() {
        sut.loadView()
        
        XCTAssertNotEqual(sut.switcher.frame, CGRect.zero)
    }

    func testHeroesListViewControllerSearchBarHasFrame() {
        sut.loadView()
        
        XCTAssertNotEqual(sut.searchBar.frame, CGRect.zero)
    }
    
    func testHeroesListViewControllerCallsFetchDefaultCharacters() {
        sut.loadView()
        sut.requestCharacters(nil)
        
        XCTAssert(outputSpy.fetchDefaultCalled)
    }
    
    func testHeroesListViewControllerCallsFetchCharactersStartingWith() {
        sut.loadView()

        sut.searchBar.text = "Hulk"
        sut.searchBarSearchButtonClicked(sut.searchBar)
        
        XCTAssertEqual(outputSpy.fetchSearchReqeust?.startsWith, "Hulk")
    }

    func testHeroesListViewControllerCallsCharacterAtID() {
        sut.loadView()
        
        let zero = IndexPath(item: 0, section: 0)
        sut.collectionView(sut.collectionView, didSelectItemAt: zero)
        
        XCTAssert(outputSpy.characterIDCalled)
    }
    
    func testHeroesListViewControllerCallsChangeListType() {
        sut.loadView()
        
        sut.switcherDidChange(UISegmentedControl())
        
        XCTAssert(outputSpy.changeListCalled)
    }
    
    /*
    func testHeroesListViewControllerCallsNextPage() {
        sut.loadView()
        
        let dataSourceFake = HeroesListCollectionFake()
        sut.collectionView.dataSource = dataSourceFake
        
        sut.requestCharacters(nil)
        let last = IndexPath(item: sut.collectionView.numberOfItems(inSection: 0) - 1, section: 0)
        sut.collectionView.scrollToItem(at: last, at: .top, animated: false)
        
        XCTAssert(outputSpy.nextPageCalled)
    }
    */
    
    func testHeroesListViewControllerPopulatesCollectionView() {
        sut.loadView()
        sut.collectionView.register(HeroesListCollectionViewCell.nib(), forCellWithReuseIdentifier: HeroesListCollectionViewCell.nibName())
        
        let fakes = createFakeItemModels()
        let vm = HeroModels.List.ViewModel(items: fakes, type: .AllHeroes, isLoading: false)
        sut.displayCharacters(vm)
        
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), fakes.count)
    }
    
    func testHeroesListViewControllerStartsSpinner() {
        sut.loadView()
        
        let emptyModel = HeroModels.List.EmptyListViewModel(message: "..", type: .Search, isLoading: true)
        sut.displayEmpty(emptyModel)
        
        XCTAssert(sut.spinner.isAnimating)
    }
    
    func testHeroesListViewControllerStopsSpinner() {
        sut.loadView()
        
        let emptyModel = HeroModels.List.EmptyListViewModel(message: "..", type: .Search, isLoading: false)
        sut.displayEmpty(emptyModel)
        
        XCTAssertFalse(sut.spinner.isAnimating)
    }
    
    func testHeroesListViewControllerDisplaysMessage() {
        sut.loadView()
        
        let emptyModel = HeroModels.List.EmptyListViewModel(message: "message", type: .Search, isLoading: true)
        sut.displayEmpty(emptyModel)
        
        XCTAssertEqual(sut.messageLabel.text, "message")
    }
    
    func testHeroesListViewControllerChangesListType() {
        sut.loadView()

        let control = UISegmentedControl(items: ["one", "two"])
        control.selectedSegmentIndex = 0
        sut.switcherDidChange(control)
        
        XCTAssert(outputSpy.changeListCalled)
    }
    
    func createFakeItemModels() -> [HeroModels.List.ItemViewModel] {
        var models : [HeroModels.List.ItemViewModel] = []
        for _ in 0...4 {
            let model = HeroModels.List.ItemViewModel(name: "FakeName", thumbnailUrl: "FakeURL")
            models.append(model)
        }
        return models
    }
}
