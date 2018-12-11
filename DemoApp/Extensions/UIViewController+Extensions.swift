//
//  UIViewController+Extensions.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 10/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Alert.defaultAction, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
