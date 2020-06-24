//
//  LoginControllerTests.swift
//  Hunout!Tests
//
//  Created by Daniel Sette on 04/08/2019.
//  Copyright © 2019 Daniel Sette. All rights reserved.
//

import Foundation

import XCTest

@testable import Hunout_

class LoginControllerTests: XCTestCase {
    
    func testIsNewUser() {
        
        let emailToTest = "dan@test.com"
        var userEmail = LoginController().isNewUser(email: emailToTest)
       
        XCTAssertTrue(userEmail == false, "dan@test.com is not a new user")
        
        let emailToTest2 = "example@test.com"
        
        userEmail = LoginController().isNewUser(email: emailToTest2)
        
        XCTAssertTrue(userEmail == true, "example@test.com is a new user")
    }
    
    func testVerifyUserDetails () {
        var email = "example@tests.com"
        var password = "12345"
        var tesVerifiedUser = LoginController().verifyUserDetails(email: email, password: password)
        XCTAssertTrue(tesVerifiedUser == false, "user is not registerd")
        
        email = "dan@test.com"
        password = "12345"
        tesVerifiedUser = LoginController().verifyUserDetails(email: email, password: password)
        XCTAssertTrue(tesVerifiedUser == true, "user is registerd")
    }
}
