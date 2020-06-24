//
//  LikesViewController.swift
//  Hunout!
//
//  Created by Daniel Sette on 28/07/2019.
//  Copyright © 2019 Daniel Sette. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import CoreLocation

class LikedPlacesCell: UITableViewCell {
    
    @IBOutlet weak var likedPlaceImg: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeAddress: UILabel!
    
    func setPlacesTable(items: LikedPlacesStruct.places) {
        
        placeName.text = items.name
        placeAddress.text = items.address
        likedPlaceImg.image = items.placeImg
        
    }
    
}


class LikesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // create an array to colect the shop products
    var likes = [LikedPlacesStruct.places]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        let currEmail = ARView().getCurrUser()
            
        likes = populateLikedArray(userEmail: currEmail)
    }
    
    @IBAction func backToMap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // populate the array
    func populateLikedArray(userEmail: String) -> [LikedPlacesStruct.places]{
        
        var tempList = [LikedPlacesStruct.places]()
        // get the current user profile
        let userDetails = realm.objects(UsersProfile.self).filter("userEmail == %@", userEmail.lowercased())
        
        var shopName: String?
        var shopAddress: String?
        var img: UIImage?
        if let userRetrieved = userDetails.first {
            
            for elem in userRetrieved.savedPlaces {
                shopAddress = elem.placeAddress
                shopName = elem.placeName
                img = UIImage(named: shopName!)!
                
                let saved = LikedPlacesStruct.places(name: shopName!, address: shopAddress!, placeImg: img!)
                
                tempList.append(saved)
            }
           
        }
        return tempList
    }
    
    func deleteLikeFromDB(i: Int) {
        
        let currEmail = ARView().getCurrUser()
        
        // get the current user profile
        let userDetails = realm.objects(UsersProfile.self).filter("userEmail == %@", currEmail.lowercased())
        
        if let userRetrieved = userDetails.first {
            
            var elems = [LikedPlacesCollection]()
            for (index, elem) in userRetrieved.savedPlaces.enumerated() {
                
                if i == index {
                    elems.append(elem)
                }
            }
            
            try! realm.write {
                realm.delete(elems)
            }
        
        }
        
    }
    
    
    // determine number of rows to be shown
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likes.count
    }
    
    // function display the data in each single cell that is created
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // make dynamic
        let likedCellsToDisplay = likes[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "likesCell") as! LikedPlacesCell
        
        // set each row
        cell.setPlacesTable(items: likedCellsToDisplay)
        
        return cell
    }
    
    
    // functions to edit the table view and delete rows/ database
    // enables to edit a row
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // enables to delete the row
    func tableView(_ tableView: UITableView, commit edtitingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var deleteAtIndex: Int?
        if edtitingStyle == .delete {
            deleteAtIndex = indexPath.row
            likes.remove(at: indexPath.row)
            deleteLikeFromDB(i: deleteAtIndex!)
        }
        
        // update the table
        tableView.beginUpdates()
        // delete
        tableView.deleteRows(at: [indexPath], with: .fade)
        // end the update operation
        tableView.endUpdates()
    }
    
    // Fuction to open google maps when saved cell is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currShop = likes[indexPath.row].name
        let shopDetails: Results<PlacesOfInterestCollection>!
        
        shopDetails = realm.objects(PlacesOfInterestCollection.self).filter("placeName == %@", currShop as Any)
        var shopCoords: String?
        
        for elem in shopDetails {
            shopCoords = elem.placeCoordinates
        }
        let splitCoords = shopCoords!.components(separatedBy: ",")

        let longitude = splitCoords[0]
        let latitude = splitCoords[1]
        
        let googleLink = "comgooglemaps://?center=\(latitude),\(longitude)&zoom=14&q=\(latitude),\(longitude)"
        
        UIApplication.shared.open((NSURL(string: googleLink)! as URL),options: [:], completionHandler: nil)
    }
}
