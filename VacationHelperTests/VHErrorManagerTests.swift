//
//  VHErrorManagerTests.swift
//  VacationHelperTests
//
//  Created by Valentin Kiselev on 9/7/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import XCTest
@testable import Vacation_Helper

class VHErrorManagerTests: XCTestCase {

	func testInitError() {
		var error = VHErrorManager.init(403)
		
		let descriptionEnding = " oops! It seems something goes wrong. Please try again later."
		
		XCTAssertNotNil(error)
		XCTAssertNotEqual(error,  VHErrorManager.unexpectedError)
		
		error = VHErrorManager.init(901)
		XCTAssertNotNil(error)
		XCTAssertEqual(error.localizedDescription,  "There is some error.\(descriptionEnding)")
		
		let error2 = VHErrorManager.init(rawValue: 901)
		XCTAssertNil(error2)
		
	}
	
	func testErrorLocalizedDescription() {
		let descriptionEnding = "oops! It seems something goes wrong. Please try again later."
		var error = VHErrorManager.forbidden
		
		XCTAssertNotNil(error)
		XCTAssertNotEqual(error,  VHErrorManager.unexpectedError)
		var localizedDescription = "You do not have access rights to the content. Please check your data"
		XCTAssertEqual(error.localizedDescription,  localizedDescription)
		
		let unexpectedErrorLocalizedDescription = "There is some error. \(descriptionEnding)"
		let unexpectedError = VHErrorManager.unexpectedError
		XCTAssertNotNil(unexpectedError)
		XCTAssertEqual(unexpectedError.localizedDescription, unexpectedErrorLocalizedDescription)
		
		
		error = .fetchFailed
		localizedDescription = "Unable to fetch data from local table. \(descriptionEnding)"
		XCTAssertNotNil(error)
		XCTAssertNotEqual(error,  unexpectedError)
		XCTAssertEqual(error.localizedDescription,  localizedDescription)
		
		error = .pageNotFound
		localizedDescription = "The server can not find the requested resource \(descriptionEnding)"
		XCTAssertEqual(error.localizedDescription,  localizedDescription)
		
		error = .missingResponce
		localizedDescription = "Missing HTTP response. \(descriptionEnding)"
		XCTAssertEqual(error.localizedDescription,  localizedDescription)
		
		error = .decodeFailed
		localizedDescription = "Date decoding failed"
		XCTAssertEqual(error.localizedDescription,  localizedDescription)

	}
	

}
