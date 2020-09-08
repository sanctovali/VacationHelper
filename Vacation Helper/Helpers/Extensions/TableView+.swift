//
//  TableView+.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 9/4/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import UIKit

extension UITableView {
	func deselectAll() {
		self.indexPathsForSelectedRows?.forEach({ (indePath) in
			self.deselectRow(at: indePath, animated: false)
			self.cellForRow(at: indePath)?.accessoryType = .none
		})
	}
}
