//
//  RespositoryMock.swift
//  Marvellous
//
//  Created by Maria Pons Sanchez on 28/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import Foundation
@testable import Marvellous

class RespositoryMock: ModelInterface {
    var stack: CoreDataStackFake = CoreDataStackFake()
    
    func clear() {
        stack.tearDown()
    }
    
    override func getCharacters(_ request: CharactersRequest, completion: @escaping(_ responseHeroes: [Hero]?, _ error: Error?) -> Void) {
        var fakes = [Hero]()
        for _ in 0..<10 {
            let hero = stack.createFakeHero()
            fakes.append(hero)
        }
        completion(fakes, nil)
    }
    
    override func getCharacters(_ request: CharactersSearchRequest, completion: @escaping(_ responseHeroes: [Hero]?, _ error: Error?) -> Void) {
        var fakes = [Hero]()
        for _ in 0..<10 {
            let hero = stack.createFakeHero()
            fakes.append(hero)
        }
        completion(fakes, nil)
    }
    
    override func getCharacter(_ identifier: Int64) -> Hero? {
        return stack.createFakeHero()
    }
    
    
}
