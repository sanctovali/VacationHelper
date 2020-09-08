//
//  ArrayExtensionTests.swift
//  VacationHelperTests
//
//  Created by Valentin Kiselev on 9/7/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import XCTest
@testable import Vacation_Helper

class ExtensionTests: XCTestCase {

	func testGetMostFrequentElement() {
		
		let array = [1, 2, 3, 1, 4, 6, 3, 2, 2, 3, 2]
		
		let expectedElement = 2
		
		let returnedElement = array.getMostFrequentElement()
		
		XCTAssertNotNil(returnedElement)
		XCTAssertEqual(returnedElement, expectedElement)
		
	}
	
	func testButtonSetupApperance() {
		let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
		button.setupApperance()
		
		XCTAssertNotNil(button)
		XCTAssertNotNil(button.layer)
		XCTAssertEqual(button.layer.cornerRadius, 6.0)
		XCTAssertEqual(button.titleColor(for: .normal), #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
		XCTAssertEqual(button.titleColor(for: .disabled), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
		XCTAssertEqual(button.layer.shadowColor, #colorLiteral(red: 0.4997962402, green: 0.6756744491, blue: 0.8326459391, alpha: 1))
		XCTAssertEqual(button.layer.shadowOffset, CGSize(width: 0.0, height: 0.0))
		XCTAssertEqual(button.layer.shadowOpacity, 0.7)
		XCTAssertEqual(button.layer.shadowRadius,  3.1)
	}
	
	func testDataIsBetween() {
		
		
		let startDate = Date.init(timeIntervalSince1970: 1599868800.0)
		let endDate = Date.init(timeIntervalSince1970: 1600041600.0)
		
		let date = Date.init(timeIntervalSince1970: 1599955200.0)
		
		XCTAssertTrue(date.isBetween(startDate, and: endDate))
	}
	
	func testStartofDay() {
		
		let dateFormatter = DateFormatter()
		dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
		let date = Date.init(timeIntervalSince1970: 1599858000.0)

		let currentDate = Date.init(timeIntervalSince1970: 1599510835.0)
		
		XCTAssertNotEqual(currentDate, date.startOfDay)
		XCTAssertEqual(date, date.startOfDay)
	}
	
	func testEndOfDay() {
		
		let dateFormatter = DateFormatter()
		dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
		let date = Date.init(timeIntervalSince1970: 1599944399.0)

		let currentDate = Date.init(timeIntervalSince1970: 1599510835.0)
		 
		XCTAssertNotEqual(currentDate, date.endOfDay)
		XCTAssertEqual(date, date.endOfDay)
	}
	
	func testGetFormattedDate() {
		let date = Date.init(timeIntervalSince1970: 1599403500.0)
		let expectedString = "Sep 6, 20"
		let format1 = "MMM d YY"
		let dateString = date.getFormattedDate(format: format1)
		
		XCTAssertNotNil(dateString)
		XCTAssertEqual(dateString, expectedString)
	}

}
