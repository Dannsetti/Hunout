//
//  LogoutViewController.swift
//  Hunout!
//
//  Created by Daniel Sette on 25/06/2019.
//  Copyright © 2019 Daniel Sette. All rights reserved.
//

import Foundation
import UIKit


// not in use delete
class LogoutViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.performSegue(withIdentifier: "unwindToViewController", sender: self)
    }
}
