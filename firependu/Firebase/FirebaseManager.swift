//
//  FirebaseManager.swift
//  firependu
//
//  Created by iosDev on 21/11/2016.
//
//

import Foundation
import Firebase

class FirebaseManager {
    public lazy var channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child("channels")
    public var channelRefHandle: FIRDatabaseHandle?
    
    public init() { }
}
