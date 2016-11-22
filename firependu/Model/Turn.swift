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
    internal var snapshot: FIRDataSnapshot? { didSet {
        key = snapshot?.key
        }
    }
    var key: String?
    var user: String
    var letter: Character
    
    var value: [String : Any] {
        get {
            var value = [String : Any]()
            value["user"] = user
            value["letter"] = String(letter)
            
            return value
        }
    }
    
    init(user: String = "", letter: Character = Character(" ")) {
        self.user = user
        self.letter = letter
    }
    
    required convenience init?(snapshot: FIRDataSnapshot) {
        guard let data = snapshot.value as? [String : Any] else { return nil }
        self.init()
        let letterString = data["letter"] as? String
        
        self.snapshot = snapshot
        self.user = data["user"] as? String ?? ""
        self.letter = Character(letterString ?? " ")
    }
    
    static func get(id pathString: String, with block:@escaping (Turn) -> Void) {
        FirebaseManager().turnsRef.child(pathString).observeSingleEvent(of: .value, with: {(snapshot) -> Void in
            if let turn = Turn(snapshot: snapshot) {
                block(turn)
            }
        })
    }
    
    func create() {
        guard let _ = Player.currentPlayer else { return }
        
        let turnsRef = FirebaseManager().turnsRef
        let newTurn = turnsRef.childByAutoId()
        newTurn.setValuesForKeys(self.value)
        
    }
    
    func update() {
        guard let key = key else { return }
        
        let turn = FirebaseManager().turnsRef.child(key)
        turn.updateChildValues(self.value)
    }
    
    func remove() {
        guard let key = key else { return }
        FirebaseManager().turnsRef.child(key).removeValue()
    }
}
