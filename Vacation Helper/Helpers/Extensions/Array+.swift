//
//  Array.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 9/4/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import Foundation

extension Array where Element: Comparable&Hashable {
	func getMostFrequentElement() -> Element? {
		let mappedItems = self.map { ($0, 1) }
		let dict = Dictionary(mappedItems, uniquingKeysWith: +)
		guard var max = dict.keys.first else { return nil }
		dict.forEach { (key, value) in
			if dict[max]! < value {
				max = key
			}
		}
		return max
	}
}
