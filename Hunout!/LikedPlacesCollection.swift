//
//  LikedPlacesCollection.swift
//  Hunout!
//
//  Created by Daniel Sette on 27/07/2019.
//  Copyright © 2019 Daniel Sette. All rights reserved.
//

import Foundation
import RealmSwift

// Collection to save the liked places under the user profile list

class LikedPlacesCollection: Object {
    // Properties of the class
    // To save them in the realm file use @objc dynamic
    
    @objc dynamic var placeName: String?
    @objc dynamic var placeAddress: String?
    @objc dynamic var placeCoordinates: String?
    
    
    
    // override PrimaryKey Fun to retrieve information
    override static func primaryKey() -> String? {
        return "placeCoordinates"
    }
    
    override var description: String { return "LikedPlacesCollection {\(String(describing: placeName)), \(String(describing: placeAddress)), \(String(describing: placeCoordinates))}" }
}



