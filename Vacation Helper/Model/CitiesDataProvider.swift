//
//  City.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 8/31/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import Foundation

final class CitiesDataProvider {
	
	class func loadData(to dataController: ManagedObjectController) {
		let cities = TempCity.loadDataFromJson()
		
		cities.forEach { (cityFromJson) in
			let newCity = dataController.newEntity(of: City.self)
			newCity.name = cityFromJson.name
			let newCoordinates = dataController.newEntity(of: Coordinates.self)
			newCoordinates.latitude = cityFromJson.coordinate.latitude
			newCoordinates.longitude = cityFromJson.coordinate.longitude
			newCity.coordinates = newCoordinates			
		}
		
	}
	
	struct TempCity: Codable {
		let name: String
		let coordinate: Coordinate
		var isSelected: Bool = false
		
		private enum CityCodingKeys: String, CodingKey {
			case name, coordinate
		}
		
		init(from decoder: Decoder) throws {
			guard let container = try? decoder.container(keyedBy: CityCodingKeys.self) else {
				let error = VHErrorManager.decodeFailed; throw error
			}
			do {
				self.name = try container.decode(String.self, forKey: .name)
				self.coordinate = try Coordinate(from: decoder)
			} catch let error {
				print("Can`t initialize Forecast. There is an error \(error)")
				throw error
			}
		}
		
		static func loadDataFromJson() -> [TempCity] {
			
			guard let url = Bundle.main.url(forResource: "cityList", withExtension: "json"),
				let data = try? Data(contentsOf: url),
				let cities = try? JSONDecoder().decode([TempCity].self, from: data)
				else {
					return []
			}
			return cities
			
		}
	}
	
	struct Coordinate: Codable {
		let latitude: Double
		let longitude: Double
		
		init() {
			latitude = 0
			longitude = 0
		}
		
	}
}
