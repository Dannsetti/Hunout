//
//  ChangePassword.swift
//  Hunout!
//
//  Created by Daniel Sette on 23/06/2019.
//  Copyright © 2019 Daniel Sette. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class ChangePassword : UIViewController {

    @IBOutlet weak var registeredName: UITextField!
    @IBOutlet weak var registeredEmail: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    
    // hide the keyboard whilst is typing
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
    }
    
    @IBAction func passwordChangeButton(_ sender: Any) {
        let rName = registeredName.text
        let rEmail = registeredEmail.text
        let newPass = newPassword.text
        var isSuccessful = true
        
        let alreadyUser = isUserRegisterd(name: rName!, email: rEmail!)
        
        if (alreadyUser == true) {
            // change password on database
            let userDetails = realm.objects(UsersProfile.self).filter("userEmail == %@", rEmail!.lowercased())
            
            if let elem = userDetails.first {
                if (newPass != "") {
                    try! realm.write {
                        elem.userPassword = newPass
                    }
                } else {
                    alertMessage(message: "Must Provide a Password", succeed: false)
                }
            }
            // Diplay Sucessful message and direct user to Login screen
            alertMessage(message: "Password Changed Successfully", succeed: isSuccessful)
            
        } else {
            isSuccessful = false
            // Display error message
            alertMessage(message: "Details Not Found", succeed: isSuccessful)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // function to check if registered name and password matched
    func isUserRegisterd(name: String, email: String) -> Bool {
        var uEmail: String!
        var uName: String!
        let userDetails = realm.objects(UsersProfile.self).filter("userEmail == %@", email.lowercased())
        
        for details in userDetails {
            uEmail = details.userEmail!
            print(uEmail!)
            uName = details.userName!
            print(uName!)
        }
        if (uEmail != nil || uName != nil) {
            if(uEmail!.lowercased() == email.lowercased() || uName!.lowercased() == name.lowercased()) {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func alertMessage(message: String, succeed: Bool) {
        // display alert
        var alertMessage = UIAlertController(title: "Warning", message: message, preferredStyle: UIAlertController.Style.alert)
        // crete ok button
        var okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:nil)
        
        if (succeed == true) {
            
            alertMessage = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertController.Style.alert)
            
            okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            })
            
            
        }
        // add ok button to alertMessage
        alertMessage.addAction(okButton)
        
        // display alert
        self.present(alertMessage, animated: true)
    }
    
}
