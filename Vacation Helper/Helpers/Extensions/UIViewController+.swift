//
//  UIViewController.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 9/5/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import UIKit

enum AlertAction {
	case ok
	
	func getAction() -> UIAlertAction {
		switch self {
		case .ok:
			return UIAlertAction(title: "Ок", style: .default, handler: nil)
		}
	}
}

extension UIViewController {
	func showAlert(with title: String, message: String, actions: [UIAlertAction], ofType type: UIAlertController.Style) {
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		actions.forEach { ac.addAction($0) }
		present(ac, animated: true, completion: nil)
	}
}
