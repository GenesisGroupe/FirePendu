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
    var word: Word
    var playerIDs: [String]
    var turnIDs: [String]

    init(gameID: String = "", name: String = "", word: String = "", playerIDs: [String] = [String](), turnIDs: [String] = [String]()) {
        self.gameID = gameID
        self.name = name
        self.word = Word(value: word)
        self.playerIDs = playerIDs
        self.turnIDs = turnIDs
    }
}
