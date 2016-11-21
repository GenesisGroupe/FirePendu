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
    lazy var gamesRef: FIRDatabaseReference = FIRDatabase.database().reference().child("games")
    lazy var playersRef: FIRDatabaseReference = FIRDatabase.database().reference().child("players")
    lazy var turnsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("turns")
    
    public init() { }
    
}
