//
//  Turn.swift
//  firependu
//
//  Created by iosDev on 21/11/2016.
//
//

import Foundation

class Turn {
    let turnID: String
    let player: Player
    let letter: Character
    
    init(turnID: String, player: Player, letter: Character) {
        self.turnID = turnID
        self.player = player
        self.letter = letter
    }
}
