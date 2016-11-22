//
//  FirebaseObjectProtocol.swift
//  firependu
//
//  Created by iosDev on 21/11/2016.
//
//

import Foundation
import FirebaseDatabase

protocol FirebaseObjectProtocol {
    var snapshot: FIRDataSnapshot! { get set }
    var key: String { get }
    var ref: FIRDatabaseReference { get }
    
    init(snapshot: FIRDataSnapshot)
    static func get(id pathString: String, with block: @escaping (Self) -> Void)
    func save()
    func update()
    func remove()
}

extension FirebaseObjectProtocol {
    var key: String { return snapshot.key }
    var ref: FIRDatabaseReference { return snapshot.ref }
}
