//
//  MapViewController.swift
//  Hunout!
//
//  Created by Daniel Sette on 23/06/2019.
//  Copyright © 2019 Daniel Sette. All rights reserved.
//

import Foundation
import UIKit
import MapKit
// library to deal with user location
import CoreLocation
import SceneKit
import RealmSwift

import DropDown


// add a CLLocationManagerDelegate extension to access the core location functionalies
class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // annotation to be sent to AR
    //var annotationDetails = MKAnnotationView()
    
    // outlet to connect and manipule the application map
    @IBOutlet weak var mapView: MKMapView!
    // initialize the CLLocationManager to get the user location
    let locationManager = CLLocationManager()
    
    //outlet for profile button dropdown menu
    @IBOutlet weak var profileButton: UIButton!
    
    // dropDown menu
    let dropDown = DropDown()
    
    //Track user position
    var userPos: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthorization()
        mapView.delegate = self
        // set the pins on the map
        setPinPlaces()
        
        // The view to which the drop down will appear on// UIView or UIBarButtonItem
        dropDown.anchorView = profileButton
        // Item to display on the dropdown menu
        dropDown.dataSource = ["Favourite Shops"]
        
        DropDown.appearance().cornerRadius = 10
        DropDown.appearance().textColor = UIColor.darkGray
        DropDown.appearance().selectedTextColor = UIColor.blue
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.lightGray
        DropDown.appearance().cellHeight = 40
        
        dropDown.width = 200
        dropDown.bottomOffset = CGPoint(x: (dropDown.anchorView?.plainView.bounds.width)!, y: 0)
        
    }
    
    func setLocation() {
        locationManager.delegate = self
        //set the desired accuracy need
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            setLocation()
            enableLocationServices()
        } else {
            // alert that user service location is not available
            alertMessage(message: "Location Services not available at the moment. Please check your internet connection", title: "Warning")
            
        }
    }
    
    // Zoom out to user current location
    func zoomOutUser() {
        // get mobile location
        let location = locationManager.location?.coordinate
        
        if (location != nil) {
            // set the location using the current location and set the view radius
            let area = MKCoordinateRegion.init(center: location!, latitudinalMeters: 250, longitudinalMeters: 250)
            // set in the mapView
            mapView.setRegion(area, animated: true)
        }
    }
    
    // Function to handle the permissions
    func enableLocationServices() {
        //locationManager.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            // Disable location features
            // alert user
            alertMessage(message: "Location services is denied or restricted. Please go to Settings to allow access", title: "Warning")
            break
            
        case .authorizedWhenInUse:
            // Enable basic location features
            // Show user location on the map
            mapView.showsUserLocation = true
            //zoom map
            zoomOutUser()
            // update user location
            locationManager.startUpdatingLocation()
            break
            
        case .authorizedAlways:
            break
        @unknown default:
            fatalError()
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


    // Handle the user moviments in the map and update the coordinates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // last user location
        let lastLocation = locations.last
        if lastLocation == nil {
            return
        } else {
            // get the new center coodinates
            let mapCentre = CLLocationCoordinate2D(latitude: lastLocation!.coordinate.latitude, longitude: lastLocation!.coordinate.longitude)
            // zoom in the new area
            let area = MKCoordinateRegion.init(center: mapCentre, latitudinalMeters: 250, longitudinalMeters: 250)
            mapView.setRegion(area, animated: true)
        }
        
    }
    // Handle changes in the authorization to get the user location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // check is location authorization changed
        enableLocationServices()
    }
    
    // colect the registered places details to pin in the map
    var shopList = [PointsOfInterest.POI]()
    func setPinPlaces() {

        let store1 = PointsOfInterest.POI(placeName:"Gap", placeCoordinates: CLLocation(latitude: 51.510270, longitude: -0.134737), placeAddress:"1-7 Shaftesbury Ave, Piccadilly Circus, Soho, London W1V 7RL", placePhone:"020 7287 8503", placeWebSite:"http://www.gap.co.uk", placeOpeningTimes: "Monday - 10am–8pm, Tuesday - 10am–8pm, Wednesday - 10am–8pm, Thursday - 10am–8pm, Friday - 10am–8pm, Saturday - 10am–8pm, Sunday - 12–6pm", placeDiscontCodes:"Get 50% off: 50OFFDAY, 20% When spend 50 or more: GIVEME20", placeIsOnSale: "Yes", placeProducts: "[Men's Clothing: Tops, Bottoms, Accessories, Jeans, Sweatshirt, Hoodie, Jackets, Underwear, T-Shirts & Polos], [Women's Clothing: Dresses, Shirts & Tops, T-Shirts, Sweaters & Sweatshirts, Bottoms, Outerwear & Blazers, Swim & Accessories]",arObj: nil)
        shopList.append(store1)
        
        let store2 = PointsOfInterest.POI(placeName:"Tesco Express", placeCoordinates:CLLocation(latitude: 51.417135, longitude: -0.073440), placeAddress:"72 Anerley Rd, Crystal Palace, London SE19 2AH", placePhone:"0345 026 9711", placeWebSite:"https://www.tesco.com/store-locator/uk/", placeOpeningTimes: "Saturday - 6am–12am, Sunday - 6am–12am, Monday - 6am–12am, Tuesday - 6am–12am, Wednesday - 6am–12am, Thursday - 6am–12am, Friday - 6am–12am", placeDiscontCodes:"Get free delivery when buy only: FREEDELI", placeIsOnSale: "No",placeProducts: "[Groceries: Fresh Food, Bakery, Frozen Food, Food Cupboard, Drinks, Baby Food, Health & Beauty], [Men's clothing: Shorts, Jeans, Shirts, Polos, Shoes, Outwear, Underwear], [Women's clothing: Dress, Skirt, Tops, Playsuit, Underwear]" ,arObj: nil)
        shopList.append(store2)
        
        let store3 = PointsOfInterest.POI(placeName:"Bob Wines", placeCoordinates:CLLocation(latitude: 51.416901, longitude: -0.072946), placeAddress:"29 Anerley Rd, London SE19 2AS", placePhone:"020 8659 6092", placeWebSite:"http://www.bobwines.co.uk/", placeOpeningTimes: "Monday - Closed, Tuesday - 4–9pm, Wednesday - 4–9pm, Thursday - 4–9pm, Friday - 12–9pm, Saturday - 11am–9pm, Sunday - 12–7pm", placeDiscontCodes:"No vouchers", placeIsOnSale: "Yes", placeProducts: "[Wines: Red, White, Green, Rose], [Beers: IPA, Larger, Ale, Stout, Wheat]" ,arObj: nil)
        shopList.append(store3)
        
        //add shops in the database
        addPinDetailsToDataBase(pin: shopList)
        // for each pin in the list add in the map
        for pin in shopList {
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = pin.placeCoordinates.coordinate
            annotation.title = pin.placeName
            annotation.subtitle = pin.placeAddress
            
            mapView.addAnnotation(annotation)
            
        }
    }
    
    
    // check if shop details is already in the database
    func isLocationRegistered (coord: String) -> Bool{
        
        // create var to check coord saved on the db
        var coords : Results<PlacesOfInterestCollection>!
        var dbCoord: String!
        var flag = true
        
        // retrive the object added to the database inside of the collection
        coords = realm.objects(PlacesOfInterestCollection.self).filter("placeCoordinates == %@", coord)
        
        for details in coords {
            dbCoord = details.placeCoordinates!
        }
        if (dbCoord != nil) {
            if(dbCoord == coord){
                flag = false
            } else {
                print("Check")
            }
        }
        return flag
    }
    
    
    // funtion to add pin details from the database
    func addPinDetailsToDataBase(pin: [PointsOfInterest.POI]) {
        
        for detail in pin {
            let shop = PlacesOfInterestCollection()
            
            let coord = detail.placeCoordinates
            let longitude = coord.coordinate.longitude
            let latitude = coord.coordinate.latitude
            let strLongitude = String(longitude)
            let strLatitude = String(latitude)
            let coorsString = String(strLongitude + "," + strLatitude)
            
            let isLocation = isLocationRegistered(coord: coorsString)
            
            shop.placeName = detail.placeName
            shop.placeCoordinates = coorsString
            shop.placeAddress = detail.placeAddress
            shop.placePhone = detail.placePhone
            shop.placeWebSite = detail.placeWebSite
            shop.placeOpeningTimes = detail.placeOpeningTimes
            shop.placeDiscontCodes = detail.placeDiscontCodes
            shop.placeIsOnSale = detail.placeIsOnSale
            shop.placeProducts = detail.placeProducts
            
            if isLocation == true {
                try! realm.write {
                    realm.add(shop)
                }
            } else {
                print("In the DB")
            }
        }
    }
    
    // display pin name and address on map when pressed
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView != nil {
            annotationView!.annotation = annotation
            
        } else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.frame.size.height = 40
            annotationView!.frame.size.width = 40
            annotationView!.canShowCallout = true
        }
        
        return annotationView
    }
        
        
    // get updated user location in the map
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.userPos = userLocation.location
    }
    
    // Trigger the AR screen when user is close to a Pin
    // save pin pressed coordinates to database collection to identify shop
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let coordsId = CoordToBeRetrieved()
        // is the location is the same return
        if view.annotation is MKUserLocation {
            return
        }
        
        let coords = view.annotation!.coordinate
    
        if let userCoords = userPos {
            // if user is 20 meters away and tap the pin it will trigger the
            // AR View Controller
            if userCoords.distance(from: CLLocation(latitude: coords.latitude, longitude: coords.longitude)) < 20 {
                //Call the ARView screen
                let strLongiCoords = String(coords.longitude)
                let strLatiCoords = String(coords.latitude)
                
                let strCoords = strLongiCoords + "," + strLatiCoords
                // save the coord to the collection
                coordsId.name = "cID"
                coordsId.coordinates = strCoords
                
                let changeCoords = isCoordEqual(coord: strCoords)
                
                if changeCoords == true {
                    let saveCoord = realm.objects(CoordToBeRetrieved.self).filter("name == %@", "cID")
                
                    if let elem = saveCoord.first {
                        try! realm.write {
                            elem.coordinates = strCoords
                        }
                    }
                }
                
                let screenView = UIStoryboard(name: "Main", bundle: Bundle.main)
                let ARScreen: UIViewController =  (screenView.instantiateViewController(withIdentifier: "ARView") as UIViewController)
                self.present(ARScreen, animated: true, completion: nil)
            
            }
            
        }
    }
    
    // check if shop details is already in the database
    func isCoordEqual (coord: String) -> Bool{
        
        // create var to check coord saved on the db
        var coords : Results<CoordToBeRetrieved>!
        var dbCoord: String!
        var flag = true
        
        // retrive the object added to the database inside of the collection
        coords = realm.objects(CoordToBeRetrieved.self).filter("name == %@", "cID")
        
        for details in coords {
            dbCoord = details.coordinates!
        }
        if (dbCoord != nil) {
            if(dbCoord == coord){
                flag = false
            } else {
                print("Coord not equal")
                
            }
        } else {
            // add object name to the coords to retrieve db collection
            let coordsId = CoordToBeRetrieved()
            coordsId.name = "cID"
            coordsId.coordinates = ""
            
            try! realm.write {
                realm.add(coordsId)
            }
        }
        return flag
    }
    
    // action for profile button
    @IBAction func profileButtonOpen(_ sender: Any) {
        dropDown.show()
        // Action triggered on selection
        dropDown.selectionAction = { (index: Int, item: String) in
            // when pressed trigger segue to liked view
            self.performSegue(withIdentifier: "LikesView", sender: self)
            
        }
    }
}



