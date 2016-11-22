//
//  Player.swift
//  firependu
//
//  Created by iosDev on 21/11/2016.
//
//

import Foundation

class Player {
    var playerID: String
    var nickName: String
    var score: Int
    
    init(playerID: String = "", nickName: String = "", score: Int = 0) {
        self.playerID = playerID
        self.nickName = nickName
        self.score = score
    }
}
