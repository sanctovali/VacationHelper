//
//  City.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 8/31/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import Foundation

final class CitiesDataProvider {
	
	class func loadData() {
		let cities = loadDataFromJson()

		let dataController = CityDataController.shared
		cities.forEach { (cityFromJson) in
			let newCity = dataController.newEntity(of: City.self)
			newCity.name = cityFromJson.name
			let newCoordinates = dataController.newEntity(of: Coordinates.self)
			newCoordinates.latitude = cityFromJson.coordinates.latitude
			newCoordinates.longitude = cityFromJson.coordinates.longitude
			newCity.coordinates = newCoordinates
		}
	}
	
	class func loadDataFromJson() -> [City] {
		guard let url = Bundle.main.url(forResource: "cityList", withExtension: "json"),
			let data = try? Data(contentsOf: url),
			let cities = try? JSONDecoder().decode([City].self, from: data)
			else {

				return []
		}
		return cities		
	}
	
	class func generateExportFile(for cities: [City]) -> URL? {
		let fileName = "Vacation City List"
		
		do {
			let path = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
			let fileURL: URL = path.appendingPathComponent(fileName + ".json")
			let data = try JSONEncoder().encode(cities)
			try data.write(to: fileURL, options: [])
			return fileURL
		} catch let error {
			print(error, error.localizedDescription)
			return nil
		}
	}
	
}
