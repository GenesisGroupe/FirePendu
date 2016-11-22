//
//  Turn.swift
//  firependu
//
//  Created by iosDev on 21/11/2016.
//
//

import Foundation
import Firebase

class Turn {
    let turnID: String
    let userID: String
    let letter: String
    
    init(turnID: String?, userID: String, letter: String) {
        self.turnID = turnID ?? "\(Int(NSDate().timeIntervalSince1970))"
        self.userID = userID
        self.letter = letter
    }
    
}
