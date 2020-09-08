//
//  UIButton+.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 9/4/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import UIKit

extension UIButton {
	func setupApperance() {
		self.layer.cornerRadius = self.bounds.height * 0.06
		self.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
		self.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .disabled)
		self.layer.shadowColor = #colorLiteral(red: 0.4997962402, green: 0.6756744491, blue: 0.8326459391, alpha: 1)
		self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
		self.layer.shadowOpacity = 0.7
		self.layer.shadowRadius = 3.1
	}
}
