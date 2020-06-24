//
//  PointsOfInterest.swift
//  Hunout!
//
//  Created by Daniel Sette on 06/07/2019.
//  Copyright © 2019 Daniel Sette. All rights reserved.
//

import Foundation
import CoreLocation
import SceneKit

// Shops required fields 
class PointsOfInterest {
    
    struct POI {
        let placeName: String
        let placeCoordinates: CLLocation
        let placeAddress: String
        let placePhone: String
        let placeWebSite: String
        let placeOpeningTimes: String
        let placeDiscontCodes: String
        let placeIsOnSale: String
        let placeProducts: String
        var arObj: SCNNode?
        
    }
}
