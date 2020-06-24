//
//  LoginController.swift
//  Hunout!
//
//  Created by Daniel Sette on 26/05/2019.
//  Copyright © 2019 Daniel Sette. All rights reserved.
//

import UIKit
// import the database
import RealmSwift
// import facebook sdk - used login
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import FacebookCore
import FacebookLogin
import FacebookShare

//global access to database
let realm = try! Realm()


class LoginController: UIViewController, LoginButtonDelegate {
    
    @IBOutlet weak var userLoginEmail: UITextField!
    @IBOutlet weak var userLoginPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
        // open up the realm file for the app
        // find out the path of the realm file
        print(Realm.Configuration.defaultConfiguration.fileURL as Any)
        
        // create facebook login button 
        let loginButton = FBLoginButton(frame: CGRect(x: 35, y: 670, width: view.frame.width - 76, height: 42), permissions: [ .email ])
        // To add the button
        view.addSubview(loginButton)
        // Change the default FB login button text
        let buttonText = NSAttributedString(string: "Login with Facebook")
        loginButton.setAttributedTitle(buttonText, for: .normal)
        // Command to enable the checking if the login succeed
        loginButton.delegate = self
        
        //Check if user facebook access token is true
        if (AccessToken.current != nil) {
            getFBProfileInfo()
            self.performSegue(withIdentifier: "segueToMap", sender: self)
        }
    }
    
    // variable used to set user status to loggedIn
    let userDefault = UserDefaults.standard
    
    // outlet for submit button when clicked will
    @IBAction func loginButtonEmail(_ sender: Any) {
        let uEmail = userLoginEmail.text
        let uPassword = userLoginPassword.text
        let isNew = isNewUser(email: uEmail!)
        var isVerifiedUser: Bool
        if(isNew == false) {
            isVerifiedUser = verifyUserDetails(email: uEmail!, password: uPassword!)
            if (isVerifiedUser == true) {
                // go to main page and dismiss login
                userDefault.set(true, forKey: "isLoggedIn")
//              // Waits for asynchronous updates of database
                userDefault.synchronize()
                
            } else {
                loginDetailsDontMatchAlert(message: "User Email or Password don't match")
            }
        } else {
            loginDetailsDontMatchAlert(message: "User Email or Password don't match")
        }
    }
    
    // Function to check if Facebook login succeed
    var isVerifiedUser: Bool?
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print(error as Any)
            return
        }
        // get user info and save on database
        let sendFBDetails = getFBProfileInfo()
        if (sendFBDetails == true) {
            self.userDefault.set(true, forKey: "isLoggedIn")
            self.userDefault.synchronize()
            
        }
        if (AccessToken.current != nil) {
            self.performSegue(withIdentifier: "segueToMap", sender: self)
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        return
    }
    
    // Get user information from Facebook
    var fbEmail: String?
    var fbFirstName: String?
    var fbPassword: String?
    func getFBProfileInfo() -> Bool{
        let parameters = ["fields": "id, email, name, first_name"]
        // FacebookCommand to get users personal info
        GraphRequest(graphPath: "Me", parameters: parameters).start { (connection, result, error) -> Void in
            if error != nil {
                print(error!)
                return
            }
            if let results = result as? NSDictionary {
                let id = results.object(forKey: "id") as? String
                self.fbPassword = id
                let firstName  = results.object(forKey: "first_name") as? String
                self.fbFirstName = firstName
                if let email = results.object(forKey: "email") as? String {
                    print(email)
                    self.fbEmail = "fb_"+email
                    print(self.fbEmail!)
                } else {
                    print("No email found")
                }
            }
            let users = UsersProfile()
            users.userName = self.fbFirstName
            users.userEmail = self.fbEmail
            users.userPassword = self.fbPassword
            
            // check if email is already been used by another user
            let isEmailAvailable = self.isNewUser(email: self.fbEmail!)
            
            if (isEmailAvailable == true) {
                try! realm.write {
                    realm.add(users)
                }
            }
            self.isVerifiedUser = self.verifyUserDetails(email: self.fbEmail!, password: self.fbPassword!)
        }
        return true
    }
    
    func isNewUser (email: String) -> Bool{
        
        // create var to get user email saved on the db
        var userDetails : Results<UsersProfile>!
        var uEmail: String!
        var flag = true

        // retrive the object added to the database inside of the TestRealm() collection
        // objects(collName.self) - for evething
        userDetails = realm.objects(UsersProfile.self).filter("userEmail == %@", email.lowercased())
        
        for details in userDetails {
            uEmail = details.userEmail!
        }
        if (uEmail != nil) {
            if(uEmail.lowercased() == email.lowercased()){

                flag = false
            } else {
                print("New user")
            }
        }
        return flag
    }
    
    func verifyUserDetails (email: String, password: String) -> Bool {
        // create var to get user information saved on the db
        var userDetails : Results<UsersProfile>!
        var uEmail: String!
        var uPassword: String!
        
        userDetails = realm.objects(UsersProfile.self).filter("userEmail == %@", email)
        for details in userDetails {
            uEmail = details.userEmail!
            uPassword = details.userPassword!
        }
        if (uEmail != email || uPassword != password) {
            return false
        }
        // for getting current user email in the AR view controller
        let userToRetrieve = CurrUserToBeRetrieved()
        
        userToRetrieve.name = "currUser"
        userToRetrieve.email = uEmail
        
        // if it was created already
        let cUser = realm.objects(CurrUserToBeRetrieved.self).filter("name == %@", "currUser")
            // update email
            if let elem = cUser.first {
                try! realm.write {
                    elem.email = uEmail
                }
            } else {
                try! realm.write {
                    realm.add(userToRetrieve)
                }
                
        }
        return true
    }
    
    // Alert message for login details
    func loginDetailsDontMatchAlert(message: String) {
        // display alert
        let alertMessage = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        // crete ok button
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:nil)
        // add ok button to alertMessage
        alertMessage.addAction(okButton)
        // display alert
        self.present(alertMessage, animated: true)
    }
}

// Extended UIViewController to hide keyboard while is typing
extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.keyboardHiden))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardHiden() {
        view.endEditing(true)
    }
}

