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
    
    override func getCharacters(_ request: CharactersRequest, completion: @escaping(_ responseHeroes: [Hero]?, _ error: Error?) -> Void) {
        
    }
    
    override func getCharacters(_ request: CharactersSearchRequest, completion: @escaping(_ responseHeroes: [Hero]?, _ error: Error?) -> Void) {
    
    }
    
    override func getCharacter(_ identifier: Int64) -> Hero? {
        return stack.createFakeHero()
    }
    
    
}
