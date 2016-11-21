//
//  Game.swift
//  firependu
//
//  Created by iosDev on 21/11/2016.
//
//

import Foundation

class Game {
    var name: String
    var players: [Player]
    var turns: [Turn]

    init(name: String, players: [Player], turns: [Turn]) {
        self.name = name
        self.players = players
        self.turns = turns
    }
    
}
