//
//  registerViewController.swift
//  Hunout!
//
//  Created by Daniel Sette on 16/06/2019.
//  Copyright © 2019 Daniel Sette. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


class RegisterViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    // hide the keyboard whilst is typing
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
    }
    
    // Get user information
    @IBAction func registerUser(_ sender: Any) {
        let uName = userName.text
        let uEmail = userEmail.text
        let uPassword = userPassword.text
        
        if(uEmail!.isEmpty || uPassword!.isEmpty || uName!.isEmpty) {
            
            // message
            alertMessage(message: "All fields are Required", succeed: false)
            return
        }
        
        let users = UsersProfile()
        users.userName = uName
        users.userEmail = uEmail
        users.userPassword = uPassword
        
        
        // check if email is already been used by another user
        let isEmailAvailable = LoginController().isNewUser(email: uEmail!)
        
        if (isEmailAvailable == false) {
            let alertMessage = UIAlertController(title: "Warning", message: "Email already been used", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            })
            // add ok button to alertMessage
            alertMessage.addAction(okButton)
            
            // display alert
            self.present(alertMessage, animated: true)
        } else {
            // warp the values to the database
            // everythnig to do with the realm (retrive, add, delete, so on
            // need to be written in the following wrap (write) statement
            try! realm.write {
                realm.add(users)
            }
        }
        
        // Display register successful message
        alertMessage(message: "Registration Made With Success", succeed: true)
    
    }
    
    // cancel Button
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
