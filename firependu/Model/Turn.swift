//
//  Turn.swift
//  firependu
//
//  Created by iosDev on 21/11/2016.
//
//

import Foundation
import FirebaseDatabase

final class Turn: FirebaseObjectProtocol {

    private var turnsRefHandle: FIRDatabaseHandle?
    private var turnRefHandle: FIRDatabaseHandle?
    
    internal var snapshot: FIRDataSnapshot!
    
    var turnID: String
    var playerID: String
    var letter: Character
    
    init(turnID: String = "", playerID: String = "", letter: Character = Character("")) {
        self.turnID = turnID
        self.playerID = playerID
        self.letter = letter
        super.init()
    }
    
    required convenience init(snapshot: FIRDataSnapshot) {
        self.init()
        self.snapshot = snapshot
        let turnData = snapshot.value as! Dictionary<String, AnyObject> // 2
        self.turnID = snapshot.key
        self.playerID = turnData["playerID"] as? String ?? ""
        let letterString = turnData["letter"] as? String
        self.letter = Character(letterString ?? "")
    }
    
    static func get(id pathString: String, with block:@escaping (Turn) -> Void) {
        FirebaseManager().turnsRef.child(pathString).observeSingleEvent(of: .value, with: {(snapshot) -> Void in
            let turnData = snapshot.value as! Dictionary<String, AnyObject> // 2
            let id = snapshot.key
            let playerId = turnData["playerID"] as? String ?? ""
            let letterString = turnData["letter"] as? String
            let letter = Character(letterString ?? "")
            let turn = Turn(turnID: id, playerID: playerId, letter: letter)
            block(turn)
        })
    }
    
    
    
    func save() {
        
    }
    
    func update() {
        
    }
    
    func remove() {
        
    }
}
