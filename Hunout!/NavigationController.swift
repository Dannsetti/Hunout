//
//  NavigationController.swift
//  Hunout!
//
//  Created by Daniel Sette on 23/06/2019.
//  Copyright © 2019 Daniel Sette. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: UINavigationController {
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if (ViewController().verifyUserDetails(email: <#String#>)
        let userDefault = UserDefaults.standard
        
        let savedData = userDefault.bool(forKey: "isLoggedIn")
        if(savedData){
            performSegue(withIdentifier: "MapViewController", sender:nil)//here u have decide the which view will show if the user is logged in how. here i used   segue.
            
        }else{
            ViewController().goToMainScreen()
            //viewController = self// this is the main view. just make the object of the class and called it.
        }
    }
}
