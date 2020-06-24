//
//  ProductsViewController.swift
//  Hunout!
//
//  Created by Daniel Sette on 21/07/2019.
//  Copyright © 2019 Daniel Sette. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


// class to control the table cells
class ProductViewCells: UITableViewCell {
    
    @IBOutlet weak var prodImg: UIImageView!
    @IBOutlet weak var prodType: UILabel!
    @IBOutlet weak var prodSubType: UILabel!
    
    func setItemsTable(items: ProductsStruct.products) {
        
        prodType.text = items.itemType
        prodSubType.text = items.itemSubType
        prodImg.image = items.itemImg
        
    }

}


class ProductsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // create an array to colect the shop products
    var shopProducts = [ProductsStruct.products]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let place = ARView().getCurrShop()
        
        shopProducts = populateProductArray(shopInfo: place)
        
        
    }
    
    // populate the array
    func populateProductArray(shopInfo: Results<PlacesOfInterestCollection>?) -> [ProductsStruct.products]{
        
        var tempList = [ProductsStruct.products]()
        // get the products string from the current object
        var productsStr: String?
        var shopName: String?
        for elem in shopInfo! {
            productsStr = elem.placeProducts
            shopName = elem.placeName
        }
        
        // split the products string into a list
        let products = productsStr!.components(separatedBy: "]")
        
        // get the shop image.
        var img = UIImage(named: shopName!)!
        
        var cat: String
        var typeLst: String
        // add to the list struct
        for product in products {
            
            let prodct = product.components(separatedBy: "[")
            
            for prods in prodct {
                
                let prod = prods.components(separatedBy: ":")
                
                let prodCounter = prod.count
                
                if prodCounter >= 2 {
                    
                    cat = prod[0]
                    typeLst = prod[1]
                    
                    let prodCategories = typeLst.components(separatedBy: ",")
                    
                    for prodType in prodCategories {
                        let trimmed = prodType.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        // conditional to change the image
                        // if it is available otherwise place the default shop image
                        if(cat.lowercased() == "Men's Clothing".lowercased()) {
                            
                            if (trimmed == "Bottoms") {
                                img = UIImage(named: "mBottoms")!
                            }
                            else if (trimmed == "Jeans") {
                                img = UIImage(named: "mJeans")!
                            }
                            else if (trimmed == "T-Shirts & Polos") {
                                img = UIImage(named: "mPolo")!
                            }
                            else if (trimmed == "Shirts") {
                                img = UIImage(named: "mShirts")!
                            }
                            else if (trimmed == "Tops") {
                                img = UIImage(named: "mTops")!
                            }
                            else {
                                img = UIImage(named: shopName!)!
                            }
                            
                        }
                        if(cat.lowercased() == "Women's Clothing".lowercased()) {
                            
                            if (trimmed == "Sweaters & Sweatshirts") {
                                img = UIImage(named: "wSweater")!
                            }
                            else if (trimmed == "Bottoms" || trimmed == "Skirt") {
                                img = UIImage(named: "skirt")!
                            }
                            else if (trimmed == "Shirts & Tops" || trimmed == "Tops") {
                                img = UIImage(named: "wTops")!
                            }
                            else if (trimmed == "T-Shirts") {
                                img = UIImage(named: "wTop")!
                            }
                            else if (trimmed == "Tops") {
                                img = UIImage(named: "Underwear")!
                            } else {
                                img = UIImage(named: shopName!)!
                            }
                            
                        }
                        
                        if(cat.lowercased() == "Beers".lowercased()) {
                            
                            if (trimmed == "Wheat") {
                                img = UIImage(named: "wheatBeer")!
                            } else {
                                img = UIImage(named: shopName!)!
                            }
                            
                        }
                        
                        if(cat.lowercased() == "Groceries".lowercased()) {
                            
                            if (trimmed == "Fresh Food") {
                                img = UIImage(named: "freshFood")!
                            }
                            else if (trimmed == "Frozen Food") {
                                img = UIImage(named: "frozenFood")!
                            }
                            else if (trimmed == "Health & Beauty") {
                                img = UIImage(named: "beauty")!
                            } else {
                                img = UIImage(named: shopName!)!
                            }
                            
                        }
                        
                        let prodItem = ProductsStruct.products(itemType: cat, itemSubType: trimmed, itemImg: img)
                        
                        tempList.append(prodItem)
                    }
                    
                    
                }
                
            }
        }
        return tempList
    }
    
    // Required tableview methods
    
    // determine number of rows to be shown
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopProducts.count
    }
    
    // function display the data in each single cell that is created
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // make dynamic
        let shopItems = shopProducts[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell") as! ProductViewCells
        
        // set each row
        cell.setItemsTable(items: shopItems)
        
        return cell
    }
    
    // cancel button
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
