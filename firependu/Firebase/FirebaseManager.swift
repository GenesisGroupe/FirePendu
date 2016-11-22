//
//  FirebaseManager.swift
//  firependu
//
//  Created by iosDev on 21/11/2016.
//
//

import Foundation
import FirebaseDatabase

class FirebaseManager {
    let ref = FIRDatabase.database().reference()
    let gamesRef: FIRDatabaseReference
    let playersRef: FIRDatabaseReference
    let turnsRef: FIRDatabaseReference
    
    public init() {
        gamesRef = ref.child("games")
        playersRef = ref.child("players")
        turnsRef = ref.child("turns")
    }
}
