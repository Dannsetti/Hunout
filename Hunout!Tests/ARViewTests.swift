//
//  ARViewTests.swift
//  Hunout!Tests
//
//  Created by Daniel Sette on 04/08/2019.
//  Copyright © 2019 Daniel Sette. All rights reserved.
//

import Foundation
import ARKit

import XCTest

@testable import Hunout_

class ARViewTests: XCTestCase {
    
    
    func testChangeLabel() {
        
        var nameToDisplay = ARView().changeLabel(name: "Gap")
        
        XCTAssert(shopLable == "Gap", "AR shop name is Gap")
        
        nameToDisplay = ARView().changeLabel(name: "Gap")
        XCTAssert(shopLable == nameToDisplay, "AR shop name is Gap")
        
        
        
    }

}
