//
//  DiscountsViewControler.swift
//  Hunout!
//
//  Created by Daniel Sette on 20/07/2019.
//  Copyright © 2019 Daniel Sette. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

// class to control the table cells
class DiscountViewCells: UITableViewCell {
    
    @IBOutlet weak var couponImg: UIImageView!
    @IBOutlet weak var couponCode: UILabel!
    @IBOutlet weak var couponInfo: UILabel!
    
    // set the values in the table view
    func setTable(codes: CodesStruct.codes) {
        
        couponInfo.text = codes.codeInfo
        couponCode.text = codes.disCode
        couponImg.image = codes.shopImg
        
    }
    
}



class DiscountsViewControler: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // create an array to colect the discount codes
    var disCodes = [CodesStruct.codes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let place = ARView().getCurrShop()
        
        disCodes = populateDiscountArray(shopInfo: place)
    }
    
    // populate the discount array
    func populateDiscountArray(shopInfo: Results<PlacesOfInterestCollection>?) -> [CodesStruct.codes]{
        
        var tempList = [CodesStruct.codes]()
        // get the discount string from the current object
        var discountString: String?
        var shopName: String?
        for elem in shopInfo! {
            discountString = elem.placeDiscontCodes
            shopName = elem.placeName
        }
        
        // split the discount string into a list
        let codes = discountString!.components(separatedBy: ",")
        
        // get the shop image.
        
        // add to the list struct
        for code in codes {
            let img = UIImage(named: shopName!)!
            let splitCoupon = code.components(separatedBy: ":")
            let infoCounter = splitCoupon.count
            let sInfo = splitCoupon[0]
            var sCode: String!
            if infoCounter < 2 {
                sCode = splitCoupon[0]
            } else {
                sCode = splitCoupon[1]
            }
            let discount = CodesStruct.codes(codeInfo: sInfo, disCode: sCode, shopImg: img)
            
            tempList.append(discount)
        }
        return tempList
    }
    
    // Required method to use UITableViewDataSource and UITableViewDelegate
    
    // determine number of rows to be shown
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // number of data the shop has
        return disCodes.count
    }
    
    // function display the data in each single cell that is created
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // make dynamic
        let disC = disCodes[indexPath.row]
        
        // cell to be added in the tableview
        let cell = tableView.dequeueReusableCell(withIdentifier: "discountCell") as! DiscountViewCells
        
        // set each row
        cell.setTable(codes: disC)
        
        return cell
    }
    
    // back button
    @IBAction func goBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // get the clicked cell discont code value and copy to clipboard
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        UIPasteboard.general.string = disCodes[indexPath.row].disCode
        let currCode = disCodes[indexPath.row].disCode
        alertMessage(code: currCode)
    }
    
    // display message that voucher code was copied to clipboard
    func alertMessage(code: String) {
        // display alert
        let alertMessage = UIAlertController(title: "Success", message: "Code \(code) copied to clipboard", preferredStyle: UIAlertController.Style.alert)
        // crete ok button
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:nil)
        
        // add ok button to alertMessage
        alertMessage.addAction(okButton)
        
        // display alert
        self.present(alertMessage, animated: true)
    }
}


