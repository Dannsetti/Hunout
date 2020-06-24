//
//  testRealm.swift
//  Hunout!
//
//  Created by Daniel Sette on 27/05/2019.
//  Copyright © 2019 Daniel Sette. All rights reserved.
//

import Foundation
import RealmSwift

// to let realm know that we want to save the class or its instances
// is to stating that it is a subclass of Object
class TestRealm: Object {
    // Properties of the class
    // To save them in the realm file use @objc dynamic
    @objc dynamic var userName: String?
    @objc dynamic var userEmail: String?
    @objc dynamic var userPassword: String?
}
