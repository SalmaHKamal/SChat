//
//  Extensions.swift
//  SChat
//
//  Created by Salma Hassan on 3/29/20.
//  Copyright © 2020 salma. All rights reserved.
//

import UIKit

extension UITextField {
    static func reset(textFields: UITextField...) {
        textFields.forEach { (txtField) in
            txtField.text = ""
        }
    }
}
