//
//  loginStyle.swift
//  Hunout!
//
//  Created by Daniel Sette on 01/06/2019.
//  Copyright © 2019 Daniel Sette. All rights reserved.
//

import Foundation
import UIKit

// Download built in library to customize input field
// style for the input fields
@IBDesignable
class DesignableView: UIView {
    @IBInspectable var shadow: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadow.cgColor
        }
    }
}
