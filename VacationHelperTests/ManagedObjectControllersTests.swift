//
//  ManagedObjectControllerTests.swift
//  VacationHelperTests
//
//  Created by Valentin Kiselev on 9/7/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import XCTest
@testable import Vacation_Helper
import CoreData

class ManagedObjectControllersTests: XCTestCase {
	
	var dataController: ManagedObjectController!
	var cityDataController: CityDataController!
	var newCityName: String!
	
	override func setUp() {
		super.setUp()
		newCityName = "Vacation_Helper.NewCityName"
		
		cityDataController = CityDataController.shared
		dataController = cityDataController as ManagedObjectController
	}
	
	override func tearDown() {
		super.tearDown()
		newCityName = nil
		dataController = nil
		cityDataController = nil
	}
	
	func testInitDataControllers() {
		let dataControllerInstance = ManagedObjectController()
		let cityDataControllerInstance = CityDataController.shared
		
		XCTAssertNotNil(dataControllerInstance, "dataController should not be nil")
		XCTAssertNotNil(cityDataControllerInstance, "cityDataController should not be nil")
	}
	
	func testCreateNewEntity() {
		let dataController = ManagedObjectController()
		let city = dataController.newEntity(of: City.self, needSave: false)
		XCTAssertNotNil(city, "City should not be nil")
	}
	
	func testSaveContext() {
		
		expectation(
			forNotification: .NSManagedObjectContextDidSave,
			object: dataController.context) { _ in
				return true
		}
		
		dataController.context.perform {
			let city = self.cityDataController.newEntity(of: City.self)
			city.name = self.newCityName
			city.coordinates = self.dataController.newEntity(of: Coordinates.self)
			self.cityDataController.saveData()
			XCTAssertNotNil(city)
			self.cityDataController.deleteEntites([city])
		}
		
		waitForExpectations(timeout: 2.0) { error in
			XCTAssertNil(error, "Save did not occur")
		}		
	}
	
	func testGetCity() {
		let city = cityDataController.newEntity(of: City.self)
		city.name = self.newCityName
		city.coordinates = self.dataController.newEntity(of: Coordinates.self, needSave: true)
		self.cityDataController.saveData()
		XCTAssertNotNil(city)
		
		let cities = self.cityDataController.getObjcs().filter {$0.name == self.newCityName}
		self.dataController.deleteEntites(cities)
		XCTAssertNotNil(cities)
		XCTAssertTrue(cities.count == 1)
	}
	
	func testUpdateQuery() {
		let initialCitiesCount = cityDataController.objectsCount
		cityDataController.updateQuery(with: "A")
		let afterUpdateCitiesCount = cityDataController.objectsCount
		XCTAssertTrue(initialCitiesCount > afterUpdateCitiesCount)
	}
	
	func testInitiFromDecoder() {
		let cityData = "[{\"name\":\"Адыгейск\",\"latitude\":44.8783715,\"longitude\":39.190172},{\"name\":\"Санкт-Петербург\",\"latitude\":59.939095,\"longitude\":30.315868}]".data(using: .utf8)!
		var decodedCities: [City]?
		do {
			decodedCities = try JSONDecoder().decode([City].self, from: cityData)
		} catch  {
			XCTFail()
		}
		
		XCTAssertNotNil(decodedCities)
	}
	
	func testLoadingFromFile() {
		let decodedCities = CitiesDataProvider.loadDataFromJson()
		XCTAssertNotNil(decodedCities)
		XCTAssertEqual(decodedCities.count, 1106)
		
	}
	
	func testDeleteCity() {
		
		cityDataController.refresh()
		let cities = cityDataController.getObjcs()
		cityDataController.deleteEntites(cities)
		cityDataController.saveData()
		let cityCount = cityDataController.objectsCount
		
		XCTAssertTrue(cityCount == 0)
	}
	
	func testLoadingData() {
		
		cityDataController.refresh()
		let cities = cityDataController.getObjcs()

		CitiesDataProvider.loadData()
		cityDataController.saveData()

		XCTAssertEqual(cityDataController.objectsCount, cities.count + 1106)

		cityDataController.deleteEntites(cities)
		cityDataController.saveData()

	}
	
	func testCoordinates() {
		let coordinates = dataController.newEntity(of: Coordinates.self, needSave: false)
		coordinates.latitude = 55.7
		coordinates.longitude = 37.9
		
		XCTAssertEqual(coordinates.latitude, 55.7)
		XCTAssertEqual(coordinates.longitude, 37.9)
	}
	
	func testEncode() {
		let cityData = "[{\"name\":\"Адыгейск\",\"latitude\":44.8783715,\"longitude\":39.190172},{\"name\":\"Санкт-Петербург\",\"latitude\":59.939095,\"longitude\":30.315868}]".data(using: .utf8)!
		let decodedCities = try! JSONDecoder().decode([City].self, from: cityData)
		
		let encoder = JSONEncoder()
		let adygeisk = decodedCities.first!
		var data: Data?
		do {
			data = try encoder.encode(adygeisk)
			XCTAssertNotNil(data)
		} catch {
			XCTFail()
		}
		
		do {
			let city = try JSONDecoder().decode(City.self, from: data!)
			XCTAssertEqual(city.name, adygeisk.name)
		} catch  {
			XCTFail()
		}
		
	}
	
}
