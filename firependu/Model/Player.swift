//
//  Player.swift
//  firependu
//
//  Created by iosDev on 21/11/2016.
//
//

import Foundation
import FirebaseDatabase

final class Player: FirebaseObjectProtocol {
    static var currentPlayer: Player?
    
    internal var snapshot: FIRDataSnapshot? { didSet {
        key = snapshot?.key
        }
    }
    var key: String?
    var name: String
    
    var value: [String : Any] {
        get {
            var value = [String : Any]()
            value["name"] = name
            if let key = key {
                value["uid"] = key
            }
            
            return value
        }
    }
    
    init(name: String = "") {
        self.name = name
    }
    
    required convenience init(snapshot: FIRDataSnapshot) {
        self.init()
        let data = snapshot.value as! [String : Any]
        
        self.snapshot = snapshot
        self.name = (data["name"] as? String) ?? ""
    }
    
    static func get(id pathString: String, with block: @escaping (Player) -> Void) {
        FirebaseManager().playersRef.child(pathString).observeSingleEvent(of: .value, with: {(snapshot) -> Void in
            let player = Player(snapshot: snapshot)
            block(player)
        })
    }
    
    func create() {
        guard let _ = Player.currentPlayer else { return }
        
        let playerRef = FirebaseManager().playersRef
        let newPlayer = playerRef.childByAutoId()
        newPlayer.setValuesForKeys(self.value)
    }
    
    func update() {
        guard let key = key else { return }
        
        let player = FirebaseManager().playersRef.child(key)
        player.updateChildValues(self.value)
    }
    
    func remove() {
        guard let key = key else { return }
        FirebaseManager().playersRef.child(key).removeValue()
    }
}
