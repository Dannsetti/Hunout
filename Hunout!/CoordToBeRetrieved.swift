//
//  CoordToBeRetrieved.swift
//  Hunout!
//
//  Created by Daniel Sette on 13/07/2019.
//  Copyright © 2019 Daniel Sette. All rights reserved.
//

import Foundation
import RealmSwift

// Collection to save the coordinates of the shop that the user is nearby

class CoordToBeRetrieved: Object {
    // Properties of the class
    // To save them in the realm file use @objc dynamic
    @objc dynamic var name: String?
    @objc dynamic var coordinates: String?
    
    
    
    // override PrimaryKey Fun to retrieve information
    override static func primaryKey() -> String {
        return "name"
    }
    
    override var description: String { return "CoordToBeRetrieved {\(String(describing: name)), \(String(describing: coordinates))}" }
}




