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
	
}
