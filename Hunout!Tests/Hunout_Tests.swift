//
//  Hunout_Tests.swift
//  Hunout!Tests
//
//  Created by Daniel Sette on 26/05/2019.
//  Copyright © 2019 Daniel Sette. All rights reserved.
//
import Foundation
import RealmSwift
import XCTest
@testable import Hunout_

class Hunout_Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testIsNewUser() {
        
        let emailToTest = "dan@test.com"
        var userEmail = LoginController().isNewUser(email: emailToTest)
        
        XCTAssertTrue(userEmail == false, "dan@test.com is not a new user")
        
        let emailToTest2 = "example@test.com"
        
        userEmail = LoginController().isNewUser(email: emailToTest2)
        
        XCTAssertTrue(userEmail == true, "example@test.com is a new user")
    }
    
    func testVerifyUserDetails() {
        var email = "example@tests.com"
        var password = "12345"
        var tesVerifiedUser = LoginController().verifyUserDetails(email: email, password: password)
        XCTAssertTrue(tesVerifiedUser == false, "user is not registerd")
        
        email = "dan@test.com"
        password = "12345"
        tesVerifiedUser = LoginController().verifyUserDetails(email: email, password: password)
        XCTAssertTrue(tesVerifiedUser == true, "user is registerd")
    }
    
    func testGetCurrShop() {
        var coords : Results<CoordToBeRetrieved>!
        // save the last place visited
        coords = realm.objects(CoordToBeRetrieved.self).filter("name == %@", "cID")
        var dbCoord: String!
        for details in coords {
            dbCoord = details.coordinates!
        }
        
        var placeCoords: String!
        var shopDetails: Results<PlacesOfInterestCollection>!
        shopDetails = realm.objects(PlacesOfInterestCollection.self).filter("placeCoordinates == %@", dbCoord as Any)
        for details in shopDetails {
            placeCoords = details.placeCoordinates!
        }
        
        XCTAssertTrue(dbCoord == placeCoords, "Coordinates of clicked shop match to a valid registered shop")
        
        let randomCoord = "0,0"
        dbCoord = randomCoord
        shopDetails = realm.objects(PlacesOfInterestCollection.self).filter("placeCoordinates == %@", dbCoord as Any)
        
        for details in shopDetails {
            placeCoords = details.placeCoordinates!
        }
        
        XCTAssertTrue(dbCoord != placeCoords, "Shop coordinates is not registered in the database")
        
    }
    
    func testGetLableName() {
        var dbCoord: String
        var shopDetails: Results<PlacesOfInterestCollection>!
        
        var shopName: String?
        dbCoord = "-0.072946,51.416901"
        shopDetails = realm.objects(PlacesOfInterestCollection.self).filter("placeCoordinates == %@", dbCoord as Any)
        for details in shopDetails {
            shopName = details.placeName!
        }
        XCTAssertTrue(shopName == "Bob Wines", "Coordinates of clicked shop match to Bob Wines Store")
        
        dbCoord = "-111, 2222"
        shopDetails = realm.objects(PlacesOfInterestCollection.self).filter("placeCoordinates == %@", dbCoord as Any)
        for details in shopDetails {
            shopName = details.placeName
        }
        XCTAssertFalse(shopName == nil, "Coordinates of clicked shop does not match any registered shop")
        
    }
    
    func testPopulateDiscountArray() {
        var dbCoord: String
        var shopDetails: Results<PlacesOfInterestCollection>!
        
        dbCoord = "-0.072946,51.416901" // Bob Wines
        shopDetails = realm.objects(PlacesOfInterestCollection.self).filter("placeCoordinates == %@", dbCoord as Any)
        
        var disCodes = [CodesStruct.codes]()
        
        disCodes = DiscountsViewControler().populateDiscountArray(shopInfo: shopDetails)
        
        XCTAssertTrue(disCodes.count == 1, "Returns No Vouchers")
        
        let printVoucher = disCodes[0].disCode
        
        XCTAssertTrue(printVoucher == "No vouchers", "Returns No Vouchers")
        
    }
    
    func testPopulateLikedArray() {
        var likes = [LikedPlacesStruct.places]()
        
        var currEmail = "dan@test.com"
        
        likes = LikesViewController().populateLikedArray(userEmail: currEmail)
        
        XCTAssertTrue(likes.count > 0, "More than 1 place like under this user name")
        
        let firstPlaceSaved = likes[0].name
        
        XCTAssertTrue(firstPlaceSaved == "Bob Wines", "first Liked place")
        
        
        currEmail = "dummy@example.com"
        
        likes = LikesViewController().populateLikedArray(userEmail: currEmail)
        
        XCTAssertTrue(likes.count == 0, "email not saved in the database")
    }
    
    func testDeleteLikeFromDB() {
        
        
        let currEmail = "dan@test.com"
        
        let userDetails = realm.objects(UsersProfile.self).filter("userEmail == %@", currEmail.lowercased())
    XCTAssertTrue(userDetails.first?.savedPlaces.count == 1, "user has 2 saved places")
        
        let indexToDelete = 0
        var elems = [LikedPlacesCollection]()
        
        if let userRetrieved = userDetails.first {
            
            for (index, elem) in userRetrieved.savedPlaces.enumerated() {
                
                if indexToDelete == index {
                    elems.append(elem)
                }
            }
        }
        
        XCTAssertTrue(elems.count == 1, "Array for deletion contain one element")
    }
    
    func testPopulateProductArray() {
        
        var dbCoord: String
        dbCoord = "-0.072946,51.416901"
        
        let shopDetails = realm.objects(PlacesOfInterestCollection.self).filter("placeCoordinates == %@", dbCoord as Any)
        
        var products = ProductsViewController().populateProductArray(shopInfo: shopDetails)
        
        XCTAssertTrue(products.count > 0, "Shop contains a list of products")
        
        XCTAssertTrue(products[0].itemType == "Wines", "First product category of retreved shop is Wines")
        
    }
    
    func testIsLocationRegistered() {
        
        var dbCoord: String
        dbCoord = "-0.072946,51.416901"
        
        var isRegistered = MapViewController().isLocationRegistered(coord: dbCoord)
        
        XCTAssertTrue(isRegistered == false, "Shop is registered on the database")
        
        dbCoord = "-0.134,51.510"
        
        isRegistered = MapViewController().isLocationRegistered(coord: dbCoord)
        
        XCTAssertTrue(isRegistered == true, "Shop is not registered on the database")
        
    }
    
    func testIsUserRegisterd() {
        
        let user1 = ChangePassword().isUserRegisterd(name: "Dan", email: "dan@test.com")
        
        XCTAssertTrue(user1 == true, "user is registered")
        let user2 = ChangePassword().isUserRegisterd(name: "dan", email: "dan@test.com")
        XCTAssertTrue(user2 == true, "user is registered - Not case sensitive")
        let user3 = ChangePassword().isUserRegisterd(name: "1111", email: "23333")
        XCTAssertFalse(user3 == true, "user is not registered")
        let user4 = ChangePassword().isUserRegisterd(name: "", email: "")
        XCTAssertFalse(user4 == true, "Empty string does not break the app")
        
        
    }
}
