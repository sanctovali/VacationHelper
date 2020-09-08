//
//  DatePicker+.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 8/31/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import UIKit

extension UIDatePicker {
	func setupDatePicker() -> UIToolbar {
		self.datePickerMode = .date
		var dateComponents = DateComponents()
		dateComponents.day = 7
		self.maximumDate = Calendar.current.date(byAdding: dateComponents, to: Date())
		self.date = Date()
		self.minimumDate = Date()

		let toolbar = UIToolbar()
		toolbar.sizeToFit()
		return toolbar
	}
}
