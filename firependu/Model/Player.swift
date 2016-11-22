//
//  Player.swift
//  firependu
//
//  Created by iosDev on 21/11/2016.
//
//

import Foundation
import Firebase

class Player {
    var playerID: String
    var nickName: String
    var score: Int = 0
    
    init(playerID: String, nickName: String) {
        self.playerID = playerID
        self.nickName = nickName
    }
    
    init(user: FIRUser) {
        self.playerID = user.uid
        self.nickName = user.displayName!
    }
}
