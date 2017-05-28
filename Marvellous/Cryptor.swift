//
//  Cryptor.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 26/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import Foundation
import CryptoSwift

//TODO: find a safe place
let publicKey = "e4269f535eab5233421b585d4555766c"
let privateKey = "50dbacf8c77cd0c8b6cad7f65c1fe1aaaeb8b6e1"

func createHashFromTimestampAndKeys() -> Dictionary<String, String> {
    let ts = NSDate().timeIntervalSince1970.description
    let hash = "\(ts)\(privateKey)\(publicKey)".md5()
    return ["apikey": publicKey,
            "ts": ts,
            "hash": hash]
}
