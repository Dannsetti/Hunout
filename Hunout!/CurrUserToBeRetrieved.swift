//
//  CurrUserToBeRetrieved.swift
//  Hunout!
//
//  Created by Daniel Sette on 28/07/2019.
//  Copyright © 2019 Daniel Sette. All rights reserved.
//


import Foundation
import RealmSwift

// Collection to save the active user details so we can retrieve their information from the user profile collection

class CurrUserToBeRetrieved: Object {
    // Properties of the class
    // To save them in the realm file use @objc dynamic
    @objc dynamic var name: String?
    @objc dynamic var email: String?
    
    
    
    // override PrimaryKey Fun to retrieve information
    override static func primaryKey() -> String {
        return "name"
    }
    
    override var description: String { return "CurrUserToBeRetrieved {\(String(describing: name)), \(String(describing: email))}" }
}
