//
//  Game.swift
//  firependu
//
//  Created by iosDev on 21/11/2016.
//
//

import Foundation
import Firebase

final class Game {
    var gameID: String
    var name: String
    var word: String
    var host: Player
    var guest: Player?
    var turns: [Turn] = [Turn]()

    init(gameID: String?, name: String, word: String, host: Player, guest: Player?) {
        self.gameID = gameID ?? "\(Int(NSDate().timeIntervalSince1970))"
        self.name = name
        self.word = word
        self.host = host
        self.guest = guest
    }
    
    func isOwnGame() -> Bool {
        return host.playerID == FIRAuth.auth()?.currentUser?.uid
    }
    
    
}
