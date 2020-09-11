//
//  DataExporterTests.swift
//  VacationHelperTests
//
//  Created by Valentin Kiselev on 9/9/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import XCTest
@testable import Vacation_Helper

class DataExporterTests: XCTestCase {
	
	//var sut: DataExporter!
	var dataController: ManagedObjectController!
	
	override func setUp() {
		super.setUp()
		dataController = ManagedObjectController()
	}
	
	override func tearDown() {
		super.tearDown()
		//sut = nil
		dataController = nil
	}
	

	func testExport() {
		let city = dataController.newEntity(of: City.self, needSave: false)
		let coordinates = dataController.newEntity(of: Coordinates.self, needSave: false)
		let testCityName = "TestCityName"
		let latitude = 55.09
		let longitude = 30.87
		coordinates.latitude = latitude
		coordinates.longitude = longitude
		city.name = testCityName
		city.coordinates = coordinates
		city.isSelected = true
	//	let dataExporter = DataExporter()
		
	//	dataController.
	}

}
