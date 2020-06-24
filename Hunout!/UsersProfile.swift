//
//  UsersProfile.swift
//  Hunout!
//
//  Created by Daniel Sette on 31/05/2019.
//  Copyright © 2019 Daniel Sette. All rights reserved.
//

import Foundation
import RealmSwift

// Collection of registered users
class UsersProfile: Object {
    // Properties of the class
    // To save them in the realm file use @objc dynamic
    @objc dynamic var userName: String?
    @objc dynamic var userEmail: String?
    @objc dynamic var userPassword: String?
    let savedPlaces = List<LikedPlacesCollection>()


    // override PrimaryKey Fun to retrieve information
    override static func primaryKey() -> String? {
        return "userEmail"
    }
    
    override var description: String { return "UsersProfile {\(String(describing: userName)), \(String(describing: userEmail)), \(String(describing: userPassword)), \(String(describing: savedPlaces))}" }
}


