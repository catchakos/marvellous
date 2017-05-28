//
//  RespositoryMock.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 28/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import Foundation
@testable import Marvellous

class RespositoryMock: CharactersRepository {
    var stack: CoreDataStackFake = CoreDataStackFake()
    
    func clear() {
        stack.tearDown()
    }
    
    override func getCharacters(_ request: CharactersRequest, completion: @escaping(_ success: Bool) -> Void) {
        var fakes = [Hero]()
        for _ in 0..<10 {
            let hero = stack.createFakeHero()
            fakes.append(hero)
        }
        completion(true)
    }
    
    override func getCharacters(_ request: CharactersSearchRequest, completion: @escaping(_ success: Bool) -> Void) {
        var fakes = [Hero]()
        for _ in 0..<10 {
            let hero = stack.createFakeHero()
            fakes.append(hero)
        }
        completion(true)
    }
    
    override func getCharacter(_ identifier: Int64) -> Hero? {
        return stack.createFakeHero()
    }
    
    func givenThereAreHeroes() -> [Hero] {
        var heroes = [Hero]()
        for _ in 0...5 {
            let hero = self.stack.createFakeHero()
            heroes.append(hero)
        }
        return heroes
    }
    
}
