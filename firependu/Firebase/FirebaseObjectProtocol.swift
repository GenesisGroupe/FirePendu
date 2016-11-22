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
    var snapshot: FIRDataSnapshot? { get set }
    var key: String? { get }
    var ref: FIRDatabaseReference? { get }
    var value: [String : Any] { get }
    
    init(snapshot: FIRDataSnapshot)
    static func get(id pathString: String, with block: @escaping (Self) -> Void)
    func create()
    func update()
    func remove()
}

extension FirebaseObjectProtocol {
    var ref: FIRDatabaseReference? { return snapshot?.ref }
}
