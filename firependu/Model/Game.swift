//
//  Game.swift
//  firependu
//
//  Created by iosDev on 21/11/2016.
//
//

import Foundation

final class Game {
    var gameID: String
    var name: String
    var players: [Player]
    var turns: [Turn]

    init(gameID: String, name: String, players: [Player] = [Player](), turns: [Turn] = [Turn]()) {
        self.gameID = gameID
        self.name = name
        self.players = players
        self.turns = turns
    }
    
}
