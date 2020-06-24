//
//  AppDelegate.swift
//  Hunout!
//
//  Created by Daniel Sette on 26/05/2019.
//  Copyright © 2019 Daniel Sette. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func applicationDidBecomeActive(application: UIApplication) {
        
    }
    
   // Facebook - initializes the SDK when your app launches, and lets the SDK handle results from the native Facebook app when you perform a Login or Share action.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // setup to segue to other viewcontroller after login
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        var initialViewController: UIViewController
        
        if(AccessToken.current != nil){
            let board = mainStoryboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            initialViewController = board
        }else{
            initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginController")
        }
        
        self.window?.rootViewController = initialViewController
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

