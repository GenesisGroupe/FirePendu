//
//  Game.swift
//  firependu
//
//  Created by iosDev on 21/11/2016.
//
//

import Foundation
import FirebaseDatabase
import Firebase

final class Game: FirebaseObjectProtocol {
    
    internal var snapshot: FIRDataSnapshot? { didSet {
            key = snapshot?.key
        }
    }
    var key: String?
    var name: String
    var word: Word
    var host: Player?
    var guest: Player?
    var turns: [Turn]
    var isOwnGame: Bool { get {
        guard let hostKey = self.host?.key, let currentPlayerKey = Player.currentPlayer?.key  else {
            return false
        }
            return hostKey == currentPlayerKey
        }
    }
    
    var value: [String : Any] {
        get {
            var value = [String : Any]()
            value["name"] = name
            value["word"] = word.value
            if let guest = guest {
                value["guest"] = guest.value
            }
            if let host = host {
                value["host"] = host.value
            }
            value["turns"] = turns.map { $0.value }
            
            return value
        }
    }

    init(name: String = "", word: String? = nil, guest: Player? = nil, host: Player? = nil, turns: [Turn] = [Turn]()) {
        self.name = name
        self.word = Word(word)
        self.host = host
        self.guest = guest
        self.turns = turns
    }
    
    required convenience init?(snapshot: FIRDataSnapshot) {
        guard let data = snapshot.value as? [String : Any] else { return nil }
        
        self.init()
        let name = data["name"] as? String ?? ""
        let word = data["word"] as? String
        let host = Player(snapshot: snapshot.childSnapshot(forPath: "host"))
        let guest = Player(snapshot: snapshot.childSnapshot(forPath: "guest"))
        var turns = [Turn]()
        for child in snapshot.childSnapshot(forPath: "turns").children {
            if let child = child as? FIRDataSnapshot {
                if let turn = Turn(snapshot: child) {
                    turns.append(turn)
                }
            }
        }
        
        self.snapshot = snapshot
        self.name = name
        self.word = Word(word)
        self.host = host
        self.guest = guest
        self.turns = turns
    }
    
    
    func add(turn: Turn) {
        guard let key = self.key else { return }
        
        turns.append(turn)
        FirebaseManager().gamesRef.child(key).child("turns").setValuesForKeys(turn.value)
        update()
    }
    
    static func get(id pathString: String, with block:@escaping (Game) -> Void) {
        FirebaseManager().gamesRef.child(pathString).observeSingleEvent(of: .value, with: {(snapshot) -> Void in
            if let game = Game(snapshot: snapshot) {
                block(game)
            }
        })
    }
    
    func joinGame(with block: @escaping (Bool) -> Void) {
        guard let playerKey = Player.currentPlayer?.key, guest != nil, !isOwnGame else {
            block(false)
            return
        }
        
        FirebaseManager().playersRef.child(playerKey).observeSingleEvent(of: .value, with: {[unowned self](snapshot) -> Void in
            self.guest = Player(snapshot: snapshot)
            self.update()
            block(true)
        })
    }
    
    func create() {
        guard let _ = Player.currentPlayer else { return }
        
        let gamesRef = FirebaseManager().gamesRef
        let newGame = gamesRef.childByAutoId()
        newGame.setValue(self.value)        
    }
    
    func update() {
        guard let key = key else { return }
        
        let game = FirebaseManager().gamesRef.child(key)
        game.updateChildValues(self.value)
    }
    
    func remove() {
        guard let key = key else { return }
        
        FirebaseManager().gamesRef.child(key).removeValue()
    }
}
