//
//  WeatherIconManagerTests.swift
//  VacationHelperTests
//
//  Created by Valentin Kiselev on 9/7/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import XCTest
@testable import Vacation_Helper

class WeatherIconManagerTests: XCTestCase {

	func testInitWeatherIconManager() {
		let icon = WeatherIconManager.init(rawValue: "clear-day")
		
		XCTAssertNotEqual(icon.rawValue, WeatherIconManager.UnpredictedIcon.rawValue)
		XCTAssertEqual(icon.rawValue, WeatherIconManager.ClearDay.rawValue)

	}
	
	func testImageWeatherIconManager() {
		let icon = WeatherIconManager.init(rawValue: "clear-day")
		
		let clearDayImage = #imageLiteral(resourceName: "clear-day")
		let unpredictedImage = #imageLiteral(resourceName: "unpredicted-icon")
		
		let iconImage = icon.image
		
		XCTAssertNotNil(iconImage)
		XCTAssertNotEqual(iconImage, unpredictedImage)
		XCTAssertEqual(iconImage, clearDayImage)
	}
	
}
