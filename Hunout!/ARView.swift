//
//  ARView.swift
//  Hunout!
//
//  Created by Daniel Sette on 29/06/2019.
//  Copyright © 2019 Daniel Sette. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import CoreLocation
import SceneKit
import ARKit
import AVFoundation




// extend to ARSCNViewDelegate for AR functionality
class ARView: UIViewController, ARSCNViewDelegate {
    
    var isEnabled: Bool?
    
    var shopLable: SCNText!
    
    //var to display sales tag and
    // possibily topPick
    var planeNode: SCNNode!
    //var planeImage: UIImage!
    
    // connect the scneview container to the script
    @IBOutlet weak var ARLable: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraPermission()
        
        let label = getLableName()
        
        changeLabel(name: label)
    
        ARLable.delegate = self
        self.view.sendSubviewToBack(ARLable)
    }
    
    func startAR () {
        isEnabled = true
    }
    // required to display ar item
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isEnabled == true {
            let configuration = ARWorldTrackingConfiguration()
            configuration.isLightEstimationEnabled = true
            configuration.planeDetection = .vertical

            self.ARLable.session.run(configuration, options: [])
        }
    }
    
    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied, .restricted:
            alertMessage(message: "Camera access permission is denied or restricted. Please go to Settings to allow access", title: "Warning")
        case .authorized:
            startAR()
            
        case .notDetermined:
            startAR()
        @unknown default:
            fatalError()
        }
    }
    
    // get shop name from database
    func getLableName () -> String {
        var coords : Results<CoordToBeRetrieved>!
        var dbCoord: String!
        
        coords = realm.objects(CoordToBeRetrieved.self).filter("name == %@", "cID")
        
        for details in coords {
            dbCoord = details.coordinates!
        }
        
        let shopDetails: Results<PlacesOfInterestCollection>!
        var shopName: String?
        
        shopDetails = realm.objects(PlacesOfInterestCollection.self).filter("placeCoordinates == %@", dbCoord as Any)
        
        for name in shopDetails {
            shopName = name.placeName
        }
        
        
        return shopName!
        
    }
    
    func getCurrShop () -> Results<PlacesOfInterestCollection>? {
        var coords : Results<CoordToBeRetrieved>!
        var dbCoord: String!
        
        coords = realm.objects(CoordToBeRetrieved.self).filter("name == %@", "cID")
        
        for details in coords {
            dbCoord = details.coordinates!
        }
        
        let shopDetails: Results<PlacesOfInterestCollection>!
        
        shopDetails = realm.objects(PlacesOfInterestCollection.self).filter("placeCoordinates == %@", dbCoord as Any)
        
        return shopDetails
    }
    
    func getCurrUser() -> String {
        var user : Results<CurrUserToBeRetrieved>!
        var userEmail: String!
        
        user = realm.objects(CurrUserToBeRetrieved.self).filter("name == %@", "currUser")
        
        for details in user {
            userEmail = details.email!
        }
        return userEmail
    }
    
    // x button to close the page
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func likeButton(_ sender: Any) {
        
        let details = getCurrShop()
        
        var shopName: String?
        var coords: String?
        var shopAddress: String?
        for elem in details! {
            shopName = elem.placeName
            coords = elem.placeCoordinates
            shopAddress = elem.placeAddress
        }
        
        let save = LikedPlacesCollection()
        
        // get current user details
        let currEmail = getCurrUser()
        
        let userDetails = realm.objects(UsersProfile.self).filter("userEmail == %@", currEmail.lowercased())
    
        
        if let currUser = userDetails.first {
        
            save.placeCoordinates = coords
            save.placeName = shopName
            save.placeAddress = shopAddress
            
            let checkDetails = realm.objects(UsersProfile.self).filter("userEmail == %@", currEmail.lowercased())
            
            var resultLst: List<LikedPlacesCollection>!
            for elems in checkDetails {
                resultLst = elems.savedPlaces
            }
            
            var isOnDB = false
            for checking in resultLst {
                let coord = checking.placeCoordinates
                if coord == coords {
                    isOnDB = true
                }
            }
            
            if isOnDB == false {
                try! realm.write {
                    currUser.savedPlaces.append(save)
                }
                alertMessage(message: "\(shopName!) saved in your Profile", title: "Success")
            }
        }
        
    }
    
    // display messages functions
    func alertMessage(message: String, title: String) {
        // display alert
        let alertMessage = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        // crete ok button
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:nil)
        
        // add ok button to alertMessage
        alertMessage.addAction(okButton)
        
        // display alert
        self.present(alertMessage, animated: true)
    }
    
    
    @IBOutlet weak var uiButton1: UIButton!
    
    @IBOutlet weak var uiButton2: UIButton!
    
    @IBOutlet weak var uiButton3: UIButton!
    
    @IBOutlet weak var uiButton4: UIButton!
    
    @IBOutlet weak var uiButton5: UIButton!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var textBox: UITextView!
    
    // srt used to identify the AR items navigation
    var navFlag: String?
    
    // when store pin is pressed the AR label changes
    func changeLabel (name: String) {
        
        var labelName: String?
        labelName  = name
        
        let details = getCurrShop()
        // check it is on sale
        var isSaleOn: String?
        for elem in details! {
            print(elem.placeIsOnSale!)
            isSaleOn = elem.placeIsOnSale
        }
        
        // place the sale tag node on the ARView
        if isSaleOn == "Yes" {
            placeARTag()
        }
        
        // extrusion is the thickness of the lable
        shopLable = SCNText(string: "\(String(describing: labelName!))", extrusionDepth: 1)
            
        // add colour
        let textColor = SCNMaterial()
        textColor.diffuse.contents = UIColor.cyan
            
        shopLable.materials = [textColor]
            
        // place the coords for the label to appear
        let ArNode = SCNNode()
            
        // position
        // x axis is horizontal position
        // y the vertical +  = up
        // z the depth - = away
        ArNode.position = SCNVector3(x: -0.2, y: 0.3, z: -1)
        // set the scale
        ArNode.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
        // geometry
        ArNode.geometry = shopLable
            
        // to display the AR needs to assign it as a child of the ARLable root
        ARLable.scene.rootNode.addChildNode(ArNode)
            
        // add shadows to the lable
        ARLable.autoenablesDefaultLighting = true
        
        mainView()
        
    }
    
    func placeARTag() {
        
        // geometry to display the the sales tag
        let planeGeo = SCNPlane(width: 0.3, height: 0.3)
        
        // set content with the image that we want to display
        planeGeo.firstMaterial?.diffuse.contents = UIImage(named: "saleTag")
        
        // add geometry to the ar node and the coordenates
        self.planeNode = SCNNode()
        self.planeNode.geometry = planeGeo
        self.planeNode.position = SCNVector3(-0.5, 0.3, -2)
        
        self.ARLable.scene.rootNode.addChildNode(self.planeNode!)

    }
    
    func placeARTopPick() {
        
        // geometry to display the the sales tag
        let planeGeo = SCNPlane(width: 1, height: 2)
        
        let details = getCurrShop()
        
        var name: String?
        for elem in details! {
            print(elem.placeName!)
            name = elem.placeName
        }
        var toPickImg: String?
        if name == "Gap" {
            toPickImg = "GapTopPick"
        }
        if name == "Tesco Express" {
            toPickImg = "TescoTopPick"
        }
        if name == "Bob Wines" {
            toPickImg = "BobTopPick"
        }
        
        // set content with the image that we want to display
        planeGeo.firstMaterial?.diffuse.contents = UIImage(named: toPickImg!)
        
        // add geometry to the ar node and the coordenates
        self.planeNode = SCNNode()
        self.planeNode.geometry = planeGeo
        self.planeNode.position = SCNVector3(0, 0, -2.3)
        
        self.ARLable.scene.rootNode.addChildNode(self.planeNode!)

    }
    
    
    // function that sets all the buttons to default view - start page for all shops
    func mainView() {
        
        infoLabel.isHidden = false
        infoLabel.text = ""
        // make transparent
        infoLabel.backgroundColor = UIColor.clear
        
        uiButton1.setTitle("", for: .normal)
        uiButton2.setTitle("", for: .normal)
        uiButton3.setTitle("", for: .normal)
        
        setButtonStyle(button: uiButton4, buttonText: "Categories")
        setButtonStyle(button: uiButton5, buttonText: "Month Top Pick")
        
        
        resetButton(button: uiButton1)
        resetButton(button: uiButton2)
        resetButton(button: uiButton3)
    }
    
    
    // make the button invisible
    func resetButton(button: UIButton) {
        button.isHidden = false
        button.backgroundColor = UIColor.clear
        button.setTitle("", for: .normal)
        button.layer.borderWidth = 0
        button.isEnabled = false
        
    }
    
    // set the button style for the AR view
    func setButtonStyle(button: UIButton, buttonText: String) {
        button.isHidden = false
        button.isEnabled = true
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(white: 0.5, alpha: 1.0).cgColor
        button.layer.cornerRadius = 5.0
        // alpha opacity
        button.backgroundColor = UIColor(red: 0, green: 0.5333, blue: 0.9176, alpha: 0.4)
        
        button.setTitle("\(buttonText)", for: .normal)
    }
    
    // info about shop buttons
    @IBAction func infoButton(_ sender: Any) {
        
        navFlag = "info"
        
        let details = getCurrShop()
        
        var name: String?
        for elem in details! {
            print(elem.placeName!)
            name = elem.placeName
        }
        
        updateARTxtLable(txt: name!, type: "name")
        
        // hide txtBox elements
        textBox.isHidden = true
        
        infoLabel.isHidden = false
        
        infoLabel.text = ""
        uiButton4.setTitle("", for: .normal)
        // make transparent
        infoLabel.backgroundColor = UIColor.clear
        
    
        setButtonStyle(button: uiButton1, buttonText: "Opening times")
        resetButton(button: uiButton4)
        setButtonStyle(button: uiButton2, buttonText: "Phone Number")
        setButtonStyle(button: uiButton3, buttonText: "Website")
        setButtonStyle(button: uiButton5, buttonText: "Back")
        
    }
    
    
    @IBAction func uiButton1(_ sender: UIButton) {
        
        if let uiText = uiButton1.titleLabel?.text {
            if uiText == "Opening times" {
                navFlag = "openTimes"
                
                setButtonStyle(button: uiButton5, buttonText: "Back")
                
                resetButton(button: uiButton1)
                resetButton(button: uiButton2)
                resetButton(button: uiButton3)
                resetButton(button: uiButton4)
                
                textBox.isHidden = false
                
                let details = getCurrShop()
                
                var openTimes: String?
                for elem in details! {
                    print(elem.placeOpeningTimes!)
                    openTimes = elem.placeOpeningTimes
                }
                // split by week days
                let weekDay = openTimes!.components(separatedBy: ",")
                
                let mon = weekDay[0]
                let tue = weekDay[1]
                let wed = weekDay[2]
                let thr = weekDay[3]
                let fri = weekDay[4]
                let sat = weekDay[5]
                let sun = weekDay[6]
                
                textBox.isEditable = false
                textBox.text = "\n\n \(mon)\n \(tue)\n  \(wed)\n  \(thr)\n  \(fri)\n  \(sat)\n \(sun)"
                textBox.translatesAutoresizingMaskIntoConstraints = true
                textBox.sizeToFit()
                textBox.isScrollEnabled = false
                
                uiButton5.translatesAutoresizingMaskIntoConstraints = true
                
            }
            
        }
        
    }
    
    @IBAction func uiButton2(_ sender: UIButton) {
        
        if let uiText = uiButton2.titleLabel?.text {
            if uiText == "Phone Number" {
                navFlag = "phone"
                
                setButtonStyle(button: uiButton5, buttonText: "Back")
                
                resetButton(button: uiButton1)
                resetButton(button: uiButton2)
                resetButton(button: uiButton3)
                resetButton(button: uiButton4)
                
                textBox.isHidden = false
                
                let details = getCurrShop()
                
                var phone: String?
                for elem in details! {
                    print(elem.placePhone!)
                    phone = elem.placePhone
                }
                
                textBox.isEditable = false
                // achor tag to dial phone when pressed
                textBox.dataDetectorTypes = .all
                textBox.text = phone
                
                updateARTxtLable(txt: phone!, type: "phone")
                
            }
        }
    }
    
    @IBAction func uiButton3(_ sender: Any) {
        
        if let uiText = uiButton3.titleLabel?.text {
            if uiText == "Website" {
                
                navFlag = "website"
                setButtonStyle(button: uiButton5, buttonText: "Back")
                
                resetButton(button: uiButton1)
                resetButton(button: uiButton2)
                resetButton(button: uiButton3)
                resetButton(button: uiButton4)
                
                textBox.isHidden = false
                
                let details = getCurrShop()
                
                var website: String?
                for elem in details! {
                    print(elem.placeWebSite!)
                    website = elem.placeWebSite
                }
                
                textBox.isEditable = false
                // place an anchor tag to open the shop url
                textBox.dataDetectorTypes = .link
                textBox.text = website
                
                updateARTxtLable(txt: website!, type: "website")
               
            }
        }
        
    }
    
    
    
    @IBAction func uiButton4(_ sender: Any) {
        if let uiText = uiButton4.titleLabel?.text {
            if uiText == "Categories" {
                navFlag = "categories"
                // command to proceed to next viewControllet
                performSegue(withIdentifier: "productView", sender: self)
            }
        }
    }
    
    @IBAction func uiButton5(_ sender: Any) {
        
        if let uiText = uiButton5.titleLabel?.text {
            if uiText == "Back" && navFlag == "info" {
                mainView()
            }
            else if uiText == "Back" && navFlag == "website" {
                textBox.isHidden = true
                let details = getCurrShop()
                
                var name: String?
                for elem in details! {
                    print(elem.placeName!)
                    name = elem.placeName
                }
                updateARTxtLable(txt: name!, type: "name")
                // call the button as info
                self.infoButton((Any).self)
            }
            else if uiText == "Back" && navFlag == "phone" {
                textBox.isHidden = true
                // call the button as info
                self.infoButton((Any).self)
            
            }
            else if uiText == "Back" && navFlag == "openTimes" {
                textBox.translatesAutoresizingMaskIntoConstraints = false
                textBox.isHidden = true
                // call the button as info
                self.infoButton((Any).self)
            }
            else if uiText == "Month Top Pick" {
                
                navFlag = "topPick"
                resetButton(button: uiButton1)
                placeARTopPick()
                textBox.isHidden = true
                
                updateARTxtLable(txt: "Top Pick", type: "")
            } else {
                print("else")
            }
        }
    }
    
    func updateARTxtLable(txt: String, type: String) {
        
        var colour: UIColor!
        
        if type == "website" {
            colour = UIColor.blue
        }
        else if type == "phone" {
            colour = UIColor.orange
        }
        else if type == "name" {
            colour = UIColor.cyan
        } else {
            // default colour
            colour = UIColor.gray
        }
        
        shopLable.string = txt
        
        // add colour
        let textColor = SCNMaterial()
        textColor.diffuse.contents = colour
        
        shopLable.materials = [textColor]
        
        // place the coords for the label to appear
        let ArNode = SCNNode()
        
        // position
        // x axis is horizontal position
        // y the vertical +  = up
        // z the depth - = away
        ArNode.position = SCNVector3(x: -0.2, y: 0.3, z: -1)
        // set the scale - to see it
        ArNode.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
        // geometry
        ArNode.geometry = shopLable
        
        // to display the AR needs to assign it as a child of the ARLable root
        ARLable.scene.rootNode.addChildNode(ArNode)
        
        // add shadows to the lable
        ARLable.autoenablesDefaultLighting = true
        
    }
    
    @IBAction func shreButton(_ sender: Any) {
        
        let currShop = getCurrShop()
        var currShopName: String?
        var currShopAddress: String?
        for elem in currShop! {
            currShopName = elem.placeName!
            currShopAddress = elem.placeAddress!
        }
        
        let currUser = getCurrUser()
        
        var user : Results<UsersProfile>!
        
        user = realm.objects(UsersProfile.self).filter("userEmail == %@", currUser)
        
        
        var currUserName: String!
        for details in user {
            currUserName = details.userName
        }
        
        if (currUserName == nil) {
            currUserName = "Your Friend"
        }
        let pic = UIImage(named: "icon")
        let message = "\(currUserName!), just found a great deal on \(currShopName!) at \(currShopAddress!). Come quick before it is gone!\n Download Hunount App and Find the best shop deals you too"
        
        let messageToShare = UIActivityViewController(activityItems: [message, pic!] , applicationActivities: nil)
        
        self.present(messageToShare, animated: true, completion: nil)
        
    }
    
}

