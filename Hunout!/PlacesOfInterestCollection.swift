//
//  PlacesOfInterestCollection.swift
//  Hunout!
//
//  Created by Daniel Sette on 06/07/2019.
//  Copyright © 2019 Daniel Sette. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

// collection to the shops details on the database

class PlacesOfInterestCollection: Object {
    // Properties of the class
    // To save them in the realm file use @objc dynamic
    @objc dynamic var placeName: String?
    @objc dynamic var placeCoordinates: String?
    @objc dynamic var placeAddress: String?
    @objc dynamic var placePhone: String?
    @objc dynamic var placeWebSite: String?
    @objc dynamic var placeOpeningTimes: String?
    @objc dynamic var placeTopPick: NSData?
    @objc dynamic var placeDiscontCodes: String?
    @objc dynamic var placeIsOnSale: String?
    @objc dynamic var placeProducts: String?
    
    
    
    // override PrimaryKey Fun to retrieve information
    override static func primaryKey() -> String? {
        return "placeCoordinates"
    }
    
    override var description: String { return "PlacesOfInterestCollection {\(String(describing: placeCoordinates)), \(String(describing: placeName)), \(String(describing: placeAddress)), \(String(describing: placePhone)), \(String(describing: placeWebSite)), \(String(describing: placeOpeningTimes)), \(String(describing: placeDiscontCodes)), \(String(describing: placeIsOnSale)),\(String(describing: placeProducts)), \(String(describing: placeTopPick))}" }
}



